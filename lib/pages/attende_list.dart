import 'package:arbenn/components/overlay.dart';
import 'package:arbenn/components/page_transitions.dart';
import 'package:arbenn/components/scroller.dart';
import 'package:arbenn/components/user_elements.dart';
import 'package:arbenn/data/user_data.dart';
import 'package:arbenn/pages/profile_page.dart';
import 'package:arbenn/utils/colors.dart';
import 'package:flutter/material.dart';

class AttendeList extends StatelessWidget {
  final List<UserSumarryData> attendes;
  final int? maxAttendes;
  final Nuance color;

  const AttendeList(
      {Key? key, required this.attendes, required this.color, this.maxAttendes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
      color: color,
      title: "Participants",
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ScrollList(
            color: color,
            children: attendes
                .map((a) => TextButton(
                    onPressed: () => Navigator.of(context).push(slideIn(
                        FutureProfilePage(
                            backButton: true,
                            editButton: false,
                            user: UserData.loadFromUserId(a.userId)))),
                    child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            ProfileMiniature(picture: a.picture, size: 30),
                            const SizedBox(width: 10),
                            Text(
                              a.firstName,
                              style:
                                  TextStyle(color: color.darker, fontSize: 20),
                            )
                          ],
                        ))))
                .toList()),
      ),
    );
  }
}
