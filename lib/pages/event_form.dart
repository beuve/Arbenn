import 'package:arbenn/data/user_data.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/stepper.dart';
import '../components/inputs.dart';
import '../components/scroller.dart';
import '../components/tags.dart';
import '../data/tags_data.dart';
import '../data/event_data.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class EventFormPage extends StatefulWidget {
  final Nuance color;
  final EventData? event;

  const EventFormPage({Key? key, this.color = Palette.red, this.event})
      : super(key: key);

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  List<File> _localProfilePicture = [];
  List<ImageProvider> _profilePicture = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DatePickingController _dateController = DatePickingController();
  final TextEditingController _locationController = TextEditingController();
  final TagSearch _tagSearch = TagSearch();

  @override
  void initState() {
    super.initState();
    initInfos();
  }

  initInfos() async {
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _dateController.date = widget.event!.date;
      _locationController.text = widget.event!.location;
      _tagSearch.setSelectedTags(widget.event!.tags,
          (label) => () => setState(() => _tagSearch.toggle(label)));
    }
  }

  Future<EventData> toEventData() async {
    UserSumarryData admin = widget.event != null
        ? widget.event!.admin
        : await UserSumarryData.currentUser();

    return EventData(
      eventId: widget.event != null ? widget.event!.eventId : null,
      title: _titleController.text,
      tags:
          _tagSearch.tags.where((t) => t.isActive).map((t) => t.label).toList(),
      date: _dateController.date!,
      location: _locationController.text,
      admin: admin,
      description: _descriptionController.text,
      numAttendes: widget.event != null ? widget.event!.numAttendes : 0,
    );
  }

  Step firstStep(BuildContext context) {
    return Step(
        title: Text(
          'EVENEMENT',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
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
                label: "Titre",
                color: widget.color.darker,
                autoFocus: true,
                controller: _titleController,
              ),
              const SizedBox(height: 30),
              DatePicker(
                context,
                label: "Date",
                color: widget.color.darker,
                controller: _dateController,
              ),
              const SizedBox(height: 30),
              FormInput(
                label: "Location",
                color: widget.color.darker,
                controller: _locationController,
              ),
              const SizedBox(height: 30),
              FormInput(
                label: "Description",
                color: widget.color.darker,
                controller: _descriptionController,
                minLines: 4,
              ),
            ],
          ),
        ));
  }

  Step secondStep() {
    return Step(
        title: Text(
          'TAGS',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
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

  Step thirdStep() {
    return Step(
      title: Text(
        'PHOTO(S)',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: widget.color.darker,
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
                  color: widget.color.lighter,
                ),
                decoration: BoxDecoration(
                  color: widget.color.main,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormStepper(
      color: widget.color,
      resizeOnKeyboard: const [true, true, false],
      onFinish: () async {
        EventData event = await toEventData();
        await event.save();
        Navigator.pop(context);
      },
      steps: <Step>[
        firstStep(context),
        secondStep(),
        thirdStep(),
      ],
    );
  }
}
