import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

showSnackBar({
  required BuildContext context,
  required String text,
  required IconData icon,
  required Color iconColor,
  required Color backgroundColor,
  required Color textColor,
}) {
  showTopSnackBar(
    Overlay.of(context),
    Container(
      clipBehavior: Clip.hardEdge,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: -20,
            left: MediaQuery.of(context).size.width - 125,
            child: SizedBox(
              height: 95,
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.onErrorContainer,
                size: 120,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.merge(
                      TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

showErrorSnackBar({required BuildContext context, required String text}) {
  showSnackBar(
    context: context,
    text: text,
    icon: AkarIcons.circle_x,
    iconColor: Theme.of(context).colorScheme.onError,
    backgroundColor: Theme.of(context).colorScheme.error,
    textColor: Theme.of(context).colorScheme.onError,
  );
}
