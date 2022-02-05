import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/stepper.dart';
import '../components/inputs.dart';
import '../components/scroller.dart';
import '../components/tags.dart';
import 'nav.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    final controller = TextEditingController();
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
    List<String> tagList = [
      "haha",
      "test",
      "dummy",
      "haha",
      "test",
      "dummy",
      "test",
      "dummy",
      "haha",
      "test",
      "dummy",
      "test",
      "dummy",
      "haha",
      "test",
      "dummy",
      "test",
      "dummy",
      "haha",
      "test",
      "dummy",
      "test",
      "dummy",
      "haha",
      "test",
      "dummy",
      "test",
      "dummy",
      "haha",
      "test",
      "dummy",
    ];
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
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: tags(tagList, foregroundColor: widget.color.darker),
          ),
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return FormStepper(
      color: widget.color,
      resizeOnKeyboard: const [true, true, false],
      onFinish: () {
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
