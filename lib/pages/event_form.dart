import 'dart:math';
import 'package:arbenn/components/search_location.dart';
import 'package:arbenn/components/snack_bar.dart';
import 'package:arbenn/data/event_search.dart';
import 'package:arbenn/data/locations_data.dart';
import 'package:arbenn/data/storage.dart';
import 'package:arbenn/data/user_data.dart';
import 'package:arbenn/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/utils/colors.dart';
import 'package:arbenn/components/stepper.dart';
import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/scroller.dart';
import 'package:arbenn/components/tags.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:arbenn/data/event_data.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';

class EventFormPage extends StatefulWidget {
  final Nuance color;
  final EventData? event;

  const EventFormPage({Key? key, this.color = Palette.red, this.event})
      : super(key: key);

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  List<File> _localImages = [];
  List<CloudImage> _cloudImages = [];
  int _minImageIndex = 0;
  Address? _address;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DatePickingController _dateController =
      DatePickingController(showTime: true);
  final TextEditingController _addressController = TextEditingController();
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
      _address = widget.event!.address;
      _addressController.text = widget.event!.address.toString();
      _tagSearch.setSelectedTags(widget.event!.tags, setState);
      _cloudImages = await widget.event!.getImages();
      _minImageIndex = (_cloudImages.isEmpty
                  ? [-1]
                  : (_cloudImages.length == 1
                          ? [..._cloudImages, ..._cloudImages]
                          : _cloudImages)
                      .map((i) => int.parse(i.ref.name)))
              .reduce(max) +
          1;
    }
  }

  bool _checkEvent() {
    if (_titleController.text == "") {
      showSnackBar(
          context: context,
          text: "Veillez choisir un titre pour votre ??v??nement.",
          color: widget.color);
      return true;
    } else if (_tagSearch.tags == []) {
      showSnackBar(
          context: context,
          text: "Veillez s??lectionner au moins un tag.",
          color: widget.color);
      return true;
    } else if (_dateController.date == null) {
      showSnackBar(
          context: context,
          text: "Veillez s??lectionner une date pour votre ??v??nement.",
          color: widget.color);
      return true;
    } else if (_address == null) {
      showSnackBar(
          context: context,
          text: "Veillez s??lectionner une addresse pour votre ??v??nement.",
          color: widget.color);
      return true;
    }
    return false;
  }

  void showGenericError() {
    showSnackBar(
        context: context,
        text:
            "Une erreur s'est produite pendant la sauvegarde. Verifiez votre connexion internet et recomencez.",
        color: widget.color);
  }

  Future<bool> updateSearch(EventData event) async {
    if (widget.event == null) return false;
    Function eq = const DeepCollectionEquality().equals;
    if (event.title != widget.event!.title ||
        !eq(event.tags, widget.event!.tags) ||
        event.date != widget.event!.date ||
        event.address != widget.event!.address) {
      return Search().update(event);
    }
    return false;
  }

  Future<EventData?> saveEvent() async {
    UserSumarryData admin = widget.event != null
        ? widget.event!.admin
        : UserSumarryData.currentUser();
    if (_checkEvent()) return null;
    if (widget.event != null) {
      EventData event = EventData(
        eventId: widget.event!.eventId,
        title: _titleController.text,
        tags: _tagSearch.tags
            .where((t) => t.isActive)
            .map((t) => t.data)
            .toList(),
        date: _dateController.date!,
        address: _address!,
        admin: admin,
        description: _descriptionController.text,
        numAttendes: widget.event != null ? widget.event!.numAttendes : 1,
        attendes: widget.event != null ? widget.event!.attendes : [admin],
      );
      bool errorSave = await event.save();
      bool errorIndex = await updateSearch(event);
      if (errorSave || errorIndex) {
        showGenericError();
        return null;
      }
      return event;
    } else {
      EventData? event = await EventData.saveNew(
        title: _titleController.text,
        tags: _tagSearch.tags
            .where((t) => t.isActive)
            .map((t) => t.data)
            .toList(),
        date: _dateController.date!,
        address: _address!,
        admin: admin,
        description: _descriptionController.text,
      );
      if (event == null) {
        showGenericError();
        return null;
      } else {
        bool errorIndex = await Search().create(event);
        if (errorIndex) {
          showGenericError();
          return null;
        }
        return event;
      }
    }
  }

  Step firstStep(BuildContext context) {
    final DateTime now = DateTime.now();
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
            color: widget.color,
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
                color: widget.color,
                controller: _dateController,
                startDate: now,
                stopDate: DateTime(now.year + 2),
              ),
              const SizedBox(height: 30),
              FormInput(
                label: "Addresse",
                color: widget.color.darker,
                readOnly: true,
                controller: _addressController,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchAddress(
                        color: widget.color,
                        onFinish: (a) {
                          _addressController.text = a.toString();
                          setState(() {
                            _address = a;
                          });
                        },
                      ),
                    ),
                  );
                },
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
                await _tagSearch.newSearch(query, setState);
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

  Widget imageMiniature(ImageProvider image, [double size = 20]) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: image,
          ),
        ),
        margin: const EdgeInsets.all(10),
        child: SizedBox(
          width: size,
          height: size,
        ));
  }

  Step thirdStep() {
    List<Widget> photos =
        _cloudImages.map((i) => imageMiniature(i.image)).toList() +
            _localImages.map((p) => imageMiniature(FileImage(p))).toList();
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
            ...photos,
            InkWell(
              onTap: () async {
                List<XFile>? files = await ImagePicker().pickMultiImage();
                if (files != null) {
                  setState(() => _localImages =
                      _localImages + files.map((f) => File(f.path)).toList());
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.color.main,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Icon(
                    ArbennIcons.plus,
                    size: 60,
                    color: widget.color.lighter,
                  ),
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
        EventData? event = await saveEvent();
        if (event == null) return true;
        bool error = false;
        for (var i = 0; i < _localImages.length; i++) {
          error = error ||
              await saveImage(
                      "eventImages/${event.eventId}/${_minImageIndex + i}",
                      _localImages[i].path,
                      sizes: {"": 1000})
                  .then((value) => false)
                  .onError((error, stackTrace) => true);
        }
        return false;
      },
      steps: <Step>[
        firstStep(context),
        secondStep(),
        thirdStep(),
      ],
    );
  }
}
