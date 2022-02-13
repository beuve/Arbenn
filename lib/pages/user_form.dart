import 'package:flutter/material.dart';
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

import 'package:firebase_auth/firebase_auth.dart';

class UserFormPage extends StatefulWidget {
  final Nuance color;

  const UserFormPage({Key? key, this.color = Palette.blue}) : super(key: key);

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  File? _profilePicture;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final DatePickingController _birthDateController = DatePickingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TagSearch _tagSearch = TagSearch();

  @override
  void initState() {
    super.initState();
    initInfos();
  }

  initInfos() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final UserData? infos = await UserData.loadFromEventId(user!.uid);
    if (infos != null) {
      _firstNameController.text = infos.firstName;
      _lastNameController.text = infos.lastName;
      _birthDateController.date = infos.birth;
      _cityController.text = infos.location;
      _bioController.text = infos.description;
      _phoneController.text = infos.phone ?? "";
      _tagSearch.setSelectedTags(infos.tags,
          (label) => () => setState(() => _tagSearch.toggle(label)));
    }
  }

  UserData toUserData() {
    final User? user =
        FirebaseAuth.instance.currentUser; // this shouldn't be null
    return UserData(
        userId: user!.uid,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        tags: _tagSearch.tags
            .where((t) => t.isActive)
            .map((t) => t.label)
            .toList(),
        birth: _birthDateController.date!,
        location: _cityController.text,
        phone: _phoneController.text,
        description: _bioController.text);
  }

  Step firstStep() {
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
            setState(() => _profilePicture = File(file.path));
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
              if (_profilePicture != null)
                CircleAvatar(
                  backgroundImage: FileImage(_profilePicture!),
                  radius: 230,
                ),
              Opacity(
                opacity: _profilePicture == null ? 1 : 0.25,
                child: Container(
                  width: 230,
                  height: 230,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(115)),
                      border: Border.all(
                        color: widget.color.lighter,
                        width: _profilePicture == null ? 0 : 10,
                      )),
                  child: Icon(
                    Icons.add_a_photo,
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
        await toUserData().save();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Nav()),
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
