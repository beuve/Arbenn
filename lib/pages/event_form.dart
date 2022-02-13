import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/stepper.dart';
import '../components/inputs.dart';
import '../components/scroller.dart';
import '../components/tags.dart';

class EventFormPage extends StatelessWidget {
  final Nuance color;
  const EventFormPage({Key? key, this.color = Palette.red}) : super(key: key);

  Step thirdStep() {
    return Step(
      title: Text(
        'PHOTO(S)',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: color.darker,
        ),
      ),
      content: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: GridView.count(
          crossAxisCount: 3,
          children: [
            Container(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                child: Icon(
                  Icons.add_rounded,
                  size: 60,
                  color: color.lighter,
                ),
                decoration: BoxDecoration(
                  color: color.main,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Step firstStep(BuildContext context) {
    final dateController = DatePickingController();
    return Step(
        title: Text(
          'EVENEMENT',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: color.darker,
          ),
        ),
        content: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ScrollList(
            shadowColor: color.dark,
            children: [
              const SizedBox(height: 10),
              FormInput(label: "Titre", color: color.darker, autoFocus: true),
              const SizedBox(height: 30),
              DatePicker(
                context,
                label: "Date",
                color: color.darker,
                controller: dateController,
              ),
              const SizedBox(height: 30),
              FormInput(
                label: "Location",
                color: color.darker,
              ),
              const SizedBox(height: 30),
              FormInput(
                label: "Description",
                color: color.darker,
                minLines: 4,
              ),
            ],
          ),
        ));
  }

  Step secondStep() {
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
            fontWeight: FontWeight.bold,
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
            child: Tags.static(tagList, color: color),
          ),
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return FormStepper(
      color: color,
      resizeOnKeyboard: const [true, true, false],
      steps: <Step>[
        firstStep(context),
        secondStep(),
        thirdStep(),
      ],
    );
  }
}
