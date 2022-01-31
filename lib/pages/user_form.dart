import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/stepper.dart';
import '../components/inputs.dart';
import '../components/scroller.dart';
import '../components/tags.dart';
import 'nav.dart';

class UserFormPage extends StatelessWidget {
  final Nuance color;

  const UserFormPage({Key? key, this.color = Palette.blue}) : super(key: key);

  Step firstStep() {
    return Step(
      title: Text(
        'PHOTO',
        style: TextStyle(
          fontSize: 30,
          color: color.darker,
        ),
      ),
      content: Container(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          width: 230.0,
          height: 230.0,
          child: Icon(
            Icons.add_rounded,
            size: 200,
            color: color.lighter,
          ),
          decoration: BoxDecoration(
            color: color.darker,
            shape: BoxShape.circle,
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
            color: color.darker,
          ),
        ),
        content: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ScrollList(
            shadowColor: color.dark,
            children: [
              const SizedBox(height: 10),
              FormInput(label: "Prenom", color: color.darker, autoFocus: true),
              const SizedBox(height: 30),
              FormInput(label: "Nom", color: color.darker),
              const SizedBox(height: 30),
              DatePicker(
                label: "Date de naissance",
                color: color.darker,
                controller: controller,
              ),
              const SizedBox(height: 30),
              FormInput(
                label: "Phone",
                color: color.darker,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),
              FormInput(label: "Ville", color: color.darker),
              const SizedBox(height: 30),
              FormInput(label: "Bio", color: color.darker, minLines: 4),
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
            color: color.darker,
          ),
        ),
        content: SingleChildScrollView(
            child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            margin: const EdgeInsets.only(bottom: 30),
            child: SearchInput(
              label: "Chercher des tags...",
              color: color,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: tags(tagList, foregroundColor: color.darker),
          ),
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return FormStepper(
      color: color,
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
