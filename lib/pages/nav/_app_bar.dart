import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/utils/page_transitions.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/pages/forms/event_form/event_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _AppBarButton extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;

  const _AppBarButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12),
          ),
          margin: const EdgeInsets.only(right: 10),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              size: 23,
              color: Colors.black,
            ),
          ),
        ));
  }
}

class _AppBarContent extends StatelessWidget {
  const _AppBarContent();

  void openEventForm(BuildContext context) async {
    final UserData currentUser =
        Provider.of<UserDataNotifier>(context, listen: false).value;
    Navigator.of(context).push(slideIn(EventFormPage(admin: currentUser)));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _AppBarButton(
          icon: AkarIcons.plus,
          onTap: () => openEventForm(context),
        ),
        const _AppBarButton(icon: AkarIcons.bell),
      ],
    );
  }
}

PreferredSizeWidget appBar(BuildContext context) {
  return const PreferredSize(
      preferredSize: Size.fromHeight(55), child: _AppBarContent());
}
