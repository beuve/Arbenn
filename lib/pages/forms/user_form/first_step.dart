import 'package:arbenn/pages/forms/user_form/_user_form_controller.dart';
import 'package:flutter/material.dart' hide Autocomplete, Step;
import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/components/images.dart';
import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/scroller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserFormFirstStep extends StatelessWidget {
  final UserFormController controller;
  final Function() onDeleteImage;
  final Function() onAddImage;

  const UserFormFirstStep({
    super.key,
    required this.controller,
    required this.onAddImage,
    required this.onDeleteImage,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider? image = controller.localProfilePicture != null
        ? FileImage(controller.localProfilePicture!)
        : controller.profilePicture;
    final DateTime now = DateTime.now();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ScrollList(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FormInput(
                  icon: AkarIcons.person,
                  label: AppLocalizations.of(context)!.firstname,
                  autoFocus: true,
                  controller: controller.firstName,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FormInput(
                  label: AppLocalizations.of(context)!.lastname,
                  controller: controller.lastName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DatePicker(
            icon: AkarIcons.cake,
            context,
            label: AppLocalizations.of(context)!.birth,
            controller: controller.birthDate,
            startDate: DateTime(1900),
            stopDate: DateTime(now.year - 12),
            showTime: false,
          ),
          const SizedBox(height: 20),
          CityInput(
            context,
            icon: AkarIcons.location,
            label: AppLocalizations.of(context)!.city,
            controller: controller.city,
          ),
          const SizedBox(height: 20),
          FormInput(
            icon: AkarIcons.chat_bubble,
            label: AppLocalizations.of(context)!.description,
            controller: controller.bio,
            minLines: 1,
            maxLines: 5,
          ),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.add_image,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          ImageSelector(
            images: [if (image != null) image],
            onDelete: () async {},
            onAdd: () => onAddImage(),
            maxImages: 1,
          ),
        ],
      ),
    );
  }
}
