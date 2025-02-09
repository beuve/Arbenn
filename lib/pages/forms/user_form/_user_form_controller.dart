import 'dart:io';
import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/data/storage.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:arbenn/utils/errors/exceptions.dart';
import 'package:arbenn/utils/errors/result.dart';
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
  ImageProvider? profilePicture;
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

  Result<UserData> toUserData(BuildContext context, int userId) {
    if (firstName.text == "") {
      return const Err(ArbennException("[UserForm] Missing first name",
          userMessage: "Veillez entrer votre prénom.",
          kind: ErrorKind.userInput));
    } else if (lastName.text == "") {
      return const Err(ArbennException("[UserForm] Missing last name",
          userMessage: "Veillez entrer votre nom de famille.",
          kind: ErrorKind.userInput));
    } else if (birthDate.date == null) {
      return const Err(ArbennException("[UserForm] Missing birth date",
          userMessage: "Veillez entrer votre date de naissance.",
          kind: ErrorKind.userInput));
    } else if (city.city == null) {
      return const Err(ArbennException("[UserForm] Missing city",
          userMessage: "Veillez entrer votre ville de residence.",
          kind: ErrorKind.userInput));
    } else if (tagSearch.tags == []) {
      return const Err(ArbennException("[UserForm] Missing tags",
          userMessage: "Veillez entrer au moins un centre d'intérêt.",
          kind: ErrorKind.userInput));
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
    return Ok(user);
  }

  Future<Result<UserData>> save(BuildContext context) {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    return toUserData(context, creds.userId)
        .futureBind((userData) => userData.save(creds: creds))
        .futureIter((_) => saveProfileImage(localProfilePicture!.path,
            creds: creds)) // Check for errors
        .futureIter((userData) => userData.loadPicture(creds: creds));
  }
}
