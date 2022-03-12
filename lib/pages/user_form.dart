import 'package:arbenn/components/search_location.dart';
import 'package:arbenn/data/locations_data.dart';
import 'package:arbenn/utils/icons.dart';
import 'package:flutter/material.dart' hide Autocomplete;
import '../utils/colors.dart';
import '../components/stepper.dart';
import '../components/inputs.dart';
import '../components/scroller.dart';
import '../components/tags.dart';
import '../data/tags_data.dart';
import 'nav.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../data/user_data.dart';
import '../data/storage.dart';

import 'package:firebase_auth/firebase_auth.dart';

class UserFormPage extends StatefulWidget {
  final Nuance color;
  final UserData? user;

  const UserFormPage({Key? key, this.color = Palette.blue, this.user})
      : super(key: key);

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  File? _localProfilePicture;
  ImageProvider? _profilePicture;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final DatePickingController _birthDateController = DatePickingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TagSearch _tagSearch = TagSearch();
  late City? _city;

  @override
  void initState() {
    super.initState();
    initInfos();
  }

  initInfos() async {
    final User? user =
        FirebaseAuth.instance.currentUser; // this shouldn't be null

    final UserData? infos = await UserData.loadFromUserId(user!.uid);
    if (infos != null) {
      _firstNameController.text = infos.firstName;
      _lastNameController.text = infos.lastName;
      _birthDateController.date = infos.birth;
      _cityController.text = infos.location.toString();
      _city = infos.location;
      _bioController.text = infos.description;
      _phoneController.text = infos.phone ?? "";
      _tagSearch.setSelectedTags(infos.tags,
          (label) => () => setState(() => _tagSearch.toggle(label)));
      ImageProvider? image = await loadImage(user.uid);
      if (image != null) {
        setState(() => _profilePicture = image);
      }
    }
  }

  UserData toUserData(userId) {
    return UserData(
        userId: userId,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        tags: _tagSearch.tags
            .where((t) => t.isActive)
            .map((t) => t.data)
            .toList(),
        birth: _birthDateController.date!,
        location: _city!,
        phone: _phoneController.text,
        description: _bioController.text);
  }

  Step firstStep() {
    final ImageProvider? image = _localProfilePicture != null
        ? FileImage(_localProfilePicture!)
        : _profilePicture;
    return Step(
      title: Text(
        'PHOTO',
        style: TextStyle(
          fontSize: 30,
          color: widget.color.darker,
        ),
      ),
      content: GestureDetector(
        onTap: () async {
          XFile? file =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (file != null) {
            setState(() => _localProfilePicture = File(file.path));
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            width: 230.0,
            height: 230.0,
            child: Stack(children: [
              if (image != null)
                CircleAvatar(
                  backgroundImage: image,
                  radius: 230,
                ),
              Opacity(
                opacity: image == null ? 1 : 0.25,
                child: Container(
                  width: 230,
                  height: 230,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(115)),
                      border: Border.all(
                        color: widget.color.lighter,
                        width: image == null ? 0 : 10,
                      )),
                  child: Icon(
                    ArbennIcons.addPhoto,
                    size: 100,
                    color: widget.color.lighter,
                  ),
                ),
              ),
            ]),
            decoration: BoxDecoration(
              color: widget.color.darker,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Step secondStep() {
    return Step(
        title: Text(
          'INFOS',
          style: TextStyle(
            fontSize: 30,
            color: widget.color.darker,
          ),
        ),
        content: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ScrollList(
            shadowColor: widget.color.dark,
            children: [
              const SizedBox(height: 10),
              FormInput(
                label: "Prenom",
                color: widget.color.darker,
                autoFocus: true,
                controller: _firstNameController,
              ),
              const SizedBox(height: 30),
              FormInput(
                label: "Nom",
                color: widget.color.darker,
                controller: _lastNameController,
              ),
              const SizedBox(height: 30),
              DatePicker(
                context,
                label: "Date de naissance",
                color: widget.color.darker,
                controller: _birthDateController,
                startDate: DateTime(1900),
                stopDate: DateTime(DateTime.now().year - 13),
              ),
              const SizedBox(height: 30),
              FormInput(
                label: "Phone",
                color: widget.color.darker,
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
              const SizedBox(height: 30),
              FormInput(
                label: "Ville",
                color: widget.color.darker,
                controller: _cityController,
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchCity(
                        color: widget.color,
                        onFinish: (c) {
                          print(c);
                          _cityController.text = c.toString();
                          setState(() {
                            _city = c;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              FormInput(
                label: "Bio",
                color: widget.color.darker,
                minLines: 4,
                controller: _bioController,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ));
  }

  Step thirdStep() {
    return Step(
        title: Text(
          'TAGS',
          style: TextStyle(
            fontSize: 30,
            color: widget.color.darker,
          ),
        ),
        content: SingleChildScrollView(
            child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            margin: const EdgeInsets.only(bottom: 30),
            child: SearchInput(
              label: "Chercher des tags...",
              color: widget.color,
              onChanged: (query) async {
                await _tagSearch.newSearch(query,
                    (label) => () => setState(() => _tagSearch.toggle(label)));
                setState(() => {});
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Tags(tags: _tagSearch.tags, color: widget.color),
          ),
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return FormStepper(
      color: widget.color,
      resizeOnKeyboard: const [true, true, false],
      onFinish: () async {
        final String userId = FirebaseAuth.instance.currentUser!.uid;
        UserData userData = toUserData(userId);
        await userData.save();
        User _user = FirebaseAuth.instance.currentUser!;
        if (userData.firstName != _user.displayName) {
          await _user.updateDisplayName(userData.firstName);
        }
        String? profileUrl = await userData.getPictureUrl();
        if (profileUrl != null && _user.photoURL != profileUrl) {
          await _user.updatePhotoURL(profileUrl);
        }
        if (_localProfilePicture != null) {
          await saveProfileImage(userId, _localProfilePicture!.path);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Nav(
                    currentUser: userData,
                    startingPage: widget.user == null ? 0 : 4,
                  )),
        );
      },
      steps: <Step>[
        firstStep(),
        secondStep(),
        thirdStep(),
      ],
    );
  }
}
