import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/components/images.dart';
import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/scroller.dart';
import 'package:arbenn/pages/forms/event_form/_event_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventFormFirstStep extends StatelessWidget {
  final EventFormController controller;
  final Function() onDeleteImage;
  final Function() onAddImage;

  const EventFormFirstStep({
    super.key,
    required this.controller,
    required this.onAddImage,
    required this.onDeleteImage,
  });

  @override
  Widget build(BuildContext context) {
    List<ImageProvider> image = controller.cloudImageUrl != null
        ? [NetworkImage(controller.cloudImageUrl!)]
        : [];
    if (controller.localImage != null) {
      image = [FileImage(controller.localImage!)];
    }
    final DateTime now = DateTime.now();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ScrollList(
        children: [
          const SizedBox(height: 20),
          FormInput(
            icon: AkarIcons.tag,
            label: AppLocalizations.of(context)!.title,
            autoFocus: true,
            controller: controller.title,
          ),
          const SizedBox(height: 20),
          DatePicker(
            icon: AkarIcons.calendar,
            context,
            label: AppLocalizations.of(context)!.date,
            controller: controller.date,
            startDate: now,
            stopDate: DateTime(now.year + 2),
          ),
          const SizedBox(height: 20),
          AddressInput(context,
              icon: AkarIcons.location,
              label: AppLocalizations.of(context)!.address,
              controller: controller.address),
          const SizedBox(height: 20),
          FormInput(
            icon: AkarIcons.chat_bubble,
            label: AppLocalizations.of(context)!.description,
            controller: controller.description,
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
            images: image,
            maxImages: 1,
            onDelete: onDeleteImage,
            onAdd: onAddImage,
          ),
        ],
      ),
    );
  }
}
