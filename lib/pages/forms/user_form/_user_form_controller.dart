import 'dart:io';
import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/snack_bar.dart';
import 'package:arbenn/data/storage.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserFormController {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final DatePickingController birthDate =
      DatePickingController(showTime: false);
  final TextEditingController phone = TextEditingController();
  final CityInputController city = CityInputController();
  final TextEditingController bio = TextEditingController();
  final TagSearch tagSearch = TagSearch();
  late ImageProvider? profilePicture;
  File? localProfilePicture;

  void updateFromUserData(UserData infos, Function() onTap) {
    firstName.text = infos.firstName;
    lastName.text = infos.lastName;
    birthDate.date = infos.birth;
    city.city = infos.location;
    bio.text = infos.description;
    phone.text = infos.phone ?? "";
    tagSearch.setSelectedTags(infos.tags, onTap);
    if (infos.pictureUrl != null) {
      profilePicture = NetworkImage(infos.pictureUrl!);
    }
  }

  UserData? toUserData(BuildContext context, int userId) {
    if (firstName.text == "") {
      showSnackBar(
        context: context,
        text: "Veillez entrer votre prénom.",
      );
      return null;
    } else if (lastName.text == "") {
      showSnackBar(
        context: context,
        text: "Veillez entrer votre nom de famille.",
      );
      return null;
    } else if (birthDate.date == null) {
      showSnackBar(
        context: context,
        text: "Veillez entrer votre date de naissance.",
      );
      return null;
    } else if (city.city == null) {
      showSnackBar(
        context: context,
        text: "Veillez entrer votre ville de residence.",
      );
      return null;
    } else if (tagSearch.tags == []) {
      showSnackBar(
        context: context,
        text: "Veillez entrer au moins un centre d'intérêt.",
      );
      return null;
    }
    final UserData user = UserData(
        userId: userId,
        firstName: firstName.text,
        lastName: lastName.text,
        tags: tagSearch.getSelecteTags(),
        birth: birthDate.date!,
        location: city.city!,
        phone: phone.text,
        description: bio.text);
    return user;
  }

  Future<UserData?> save(BuildContext context) async {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    UserData? userData = toUserData(context, creds.userId);
    if (userData == null) return null;
    await userData.save(creds: creds);
    if (localProfilePicture != null) {
      await saveProfileImage(
        localProfilePicture!.path,
        creds: creds,
      ).then((_) => ()).onError(
        (error, stackTrace) {
          if (context.mounted) {
            showSnackBar(
              context: context,
              text: "La photo n'a pas pu être sauvegardée",
            );
          }
          return ();
        },
      );
    }
    await userData.loadPicture(creds: creds);
    return userData;
  }
}
