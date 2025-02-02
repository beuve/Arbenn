import 'package:arbenn/data/storage.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/pages/forms/event_form/_event_form_controller.dart';
import 'package:arbenn/pages/forms/event_form/_first_step.dart';
import 'package:arbenn/pages/forms/components/_tag_selection_step.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:arbenn/components/stepper.dart';
import 'package:arbenn/data/event/event_data.dart';
import 'dart:io';
import 'package:arbenn/data/user/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventFormPage extends StatefulWidget {
  final EventData? event;
  final UserData admin;
  final Function(EventData)? onFinish;

  const EventFormPage(
      {super.key, required this.admin, this.event, this.onFinish});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final EventFormController _controller = EventFormController();

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _controller.initInfos(widget.event!, () => setState(() {}));
    }
  }

  Step firstStep(BuildContext context) {
    return Step(
      content: EventFormFirstStep(
        controller: _controller,
        onDeleteImage: () => setState(() => _controller.localImage = null),
        onAddImage: () async {
          var status = Permission.photos;
          if (await status.isPermanentlyDenied) {
            await openAppSettings();
          } else {
            Future<XFile?> ffile = ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            XFile? file = await ffile;
            if (file != null) {
              setState(() => _controller.localImage = File(file.path));
            }
          }
        },
      ),
    );
  }

  Step secondStep() {
    return Step(
      content: FormsTagSelectionStep(
        tagSearch: _controller.tagSearch,
        onSearch: (query) async {
          await _controller.tagSearch.newSearch(query, () => setState(() {}));
          setState(() => {});
        },
      ),
    );
  }

  Future<bool> onFinish(BuildContext context) async {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    EventData? event =
        await _controller.saveEvent(context, widget.admin, widget.event);
    if (event == null) return true;
    if (_controller.localImage != null) {
      await saveEventImage(event.eventId, _controller.localImage!.path,
          creds: creds);
    }
    widget.onFinish?.call(event);
    if (context.mounted) {
      Navigator.pop(context, event);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FormStepper(
      title: AppLocalizations.of(context)!.create_event,
      subtitle: AppLocalizations.of(context)!.create_event_subtitle,
      resizeOnKeyboard: const [true, true, false],
      onFinish: () => onFinish(context),
      steps: <Step>[
        firstStep(context),
        secondStep(),
      ],
    );
  }
}
