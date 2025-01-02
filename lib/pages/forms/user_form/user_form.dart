import 'dart:io';

import 'package:arbenn/data/storage.dart';
import 'package:arbenn/pages/forms/components/_tag_selection_step.dart';
import 'package:arbenn/pages/forms/user_form/_first_step.dart';
import 'package:arbenn/pages/forms/user_form/_user_form_controller.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter/material.dart' hide Autocomplete, Step;
import 'package:arbenn/components/stepper.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserFormPage extends StatefulWidget {
  final UserData? user;
  final Function(UserData) onFinish;
  final bool pop;

  const UserFormPage({
    super.key,
    required this.onFinish,
    this.user,
    this.pop = true,
  });

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final UserFormController _controller = UserFormController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _controller.updateFromUserData(widget.user!, () => setState(() {}));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  onAddImage() async {
    Future<XFile?> ffile = ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    XFile? file = await ffile;
    if (file != null) {
      setState(() => _controller.localProfilePicture = File(file.path));
    }
  }

  onDeleteImage() async {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    deleteImage(creds: creds);
    _controller.profilePicture = null;
    setState(() => _controller.localProfilePicture = null);
  }

  @override
  Widget build(BuildContext context) {
    return FormStepper(
      title: AppLocalizations.of(context)!.create_account,
      subtitle: AppLocalizations.of(context)!.tell_us_about_you,
      headerHeight: 95,
      resizeOnKeyboard: const [true, true, false],
      onFinish: () async {
        return _controller.save(context).then((userData) {
          if (userData != null) {
            widget.onFinish(userData);
            return false;
          }
          return true;
        });
      },
      close: widget.pop ? (context) => Navigator.pop(context) : null,
      steps: [
        Step(
          content: UserFormFirstStep(
            controller: _controller,
            onAddImage: onAddImage,
            onDeleteImage: onDeleteImage,
          ),
        ),
        Step(
          content: FormsTagSelectionStep(
            tagSearch: _controller.tagSearch,
            onSearch: (query) async {
              await _controller.tagSearch
                  .newSearch(query, () => setState(() {}));
              setState(() => {});
            },
          ),
        )
      ],
    );
  }
}
