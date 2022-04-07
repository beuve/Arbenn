import 'dart:async';

import 'package:arbenn/components/page_transitions.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/icons.dart';
import '../components/buttons.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'calendar_page.dart';
import 'profile_page.dart';
import '../components/app_bar.dart';
import 'event_form.dart';
import '../data/user_data.dart';
import '../data/event_data.dart';

class _PageInfos {
  final int num;
  final IconData icon;
  final Nuance color;

  const _PageInfos({
    required this.num,
    required this.icon,
    required this.color,
  });
}

class Nav extends StatefulWidget {
  final UserData currentUser;
  final int startingPage;

  const Nav({
    Key? key,
    required this.currentUser,
    this.startingPage = 0,
  }) : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  final _pagesInfos = const [
    _PageInfos(
      num: 0,
      icon: ArbennIcons.home,
      color: Palette.red,
    ),
    _PageInfos(
      num: 1,
      icon: ArbennIcons.calendar,
      color: Palette.orange,
    ),
    _PageInfos(
      num: 2,
      icon: ArbennIcons.plus,
      color: Palette.yellow,
    ),
    _PageInfos(
      num: 3,
      icon: ArbennIcons.search,
      color: Palette.green,
    ),
    _PageInfos(
      num: 4,
      icon: ArbennIcons.user,
      color: Palette.blue,
    ),
  ];
  late _PageInfos _currentPageInfos;
  // Profile infos
  late Future<List<EventDataSummary>?> adminEvents;
  // Calendar Infos
  late Stream<List<EventDataSummary>?> attendedEvents;
  late StreamSubscription<List<EventDataSummary>?> _subscription;
  late List<EventDataSummary>? futureAttendedEvents;
  late List<EventDataSummary>? pastAttendedEvents;

  void setFutureAndPastEvents(List<EventDataSummary>? events) async {
    if (events != null) {
      setState(() {
        futureAttendedEvents = events
            .where((event) => event.date.isAfter(DateTime.now()))
            .toList();
        pastAttendedEvents = events
            .where((event) => event.date.isBefore(DateTime.now()))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    adminEvents = widget.currentUser.loadAdminEvents();
    futureAttendedEvents = null;
    pastAttendedEvents = null;
    attendedEvents = widget.currentUser.loadAttendesEvents();
    _subscription = attendedEvents.listen(setFutureAndPastEvents);
    _currentPageInfos = _pagesInfos[widget.startingPage];
  }

  Widget _buildNavBar(BuildContext context) {
    final List<Widget> buttons = _pagesInfos.map(
      (pageInfos) {
        Function() onPressed = pageInfos.num == 2
            ? () => Navigator.of(context).push(slideIn(const EventFormPage()))
            : () => setState(() => _currentPageInfos = pageInfos);
        Widget icon = Container(
            margin: EdgeInsets.only(
              bottom: pageInfos.num == 2 ? 2 : 5,
            ),
            child: Icon(pageInfos.icon,
                size: pageInfos.num == 2 ? 45 : 30,
                color: pageInfos.num == _currentPageInfos.num
                    ? _currentPageInfos.color.darker
                    : _currentPageInfos.color.lighter));
        return NavButton(
          color: _currentPageInfos.color,
          icon: icon,
          isFirst: pageInfos.num == 0,
          isLast: pageInfos.num == _pagesInfos.length - 1,
          isActive: pageInfos.num == _currentPageInfos.num,
          onPressed: onPressed,
        );
      },
    ).toList();
    return Container(
      color: _currentPageInfos.color.lighter,
      child: Container(
        decoration: BoxDecoration(
          color: _currentPageInfos.color.main,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(children: buttons),
      ),
    );
  }

  Widget _getContent() {
    switch (_currentPageInfos.num) {
      case 0:
        return HomePage(currentUser: widget.currentUser);
      case 1:
        return CalendarPage(
          pastEvents: pastAttendedEvents,
          futureEvents: futureAttendedEvents,
        );
      case 3:
        return SearchPage(currentUser: widget.currentUser);
      case 4:
        return ProfilePage(
          user: widget.currentUser,
          adminEvents: adminEvents,
        );
      default:
        throw Exception("Wtf");
    }
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: _currentPageInfos.color.main,
            child: Container(
              decoration: BoxDecoration(
                color: _currentPageInfos.color.lighter,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: _getContent(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _currentPageInfos.color.main,
      child: SafeArea(
        child: Scaffold(
          body: _buildContent(context),
          appBar: appBar(context, _currentPageInfos.color),
          bottomNavigationBar: _buildNavBar(context),
        ),
      ),
    );
  }
}
