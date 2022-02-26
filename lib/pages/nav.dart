import 'package:flutter/foundation.dart';
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
  final Widget content;
  final Nuance color;

  const _PageInfos({
    required this.num,
    required this.icon,
    required this.content,
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
  late _PageInfos _currentPageInfos;
  late List<_PageInfos> _pagesInfos;
  late Future<List<EventDataSummary>> adminEvents;
  late Future<List<EventDataSummary>> attendedEvents;

  void reloadAdminEventsList() {
    adminEvents = widget.currentUser.loadAdminEvents();
  }

  void reloadAttendedEventsList() {
    attendedEvents = widget.currentUser.loadAttendesEvents();
  }

  @override
  void initState() {
    super.initState();
    reloadAdminEventsList();
    reloadAttendedEventsList();
    _pagesInfos = [
      const _PageInfos(
        num: 0,
        icon: ArbennIcons.home,
        content: HomePage(),
        color: Palette.red,
      ),
      _PageInfos(
        num: 1,
        icon: ArbennIcons.calendar,
        content: CalendarPage(eventsData: attendedEvents),
        color: Palette.orange,
      ),
      _PageInfos(
        num: 2,
        icon: ArbennIcons.plus,
        content: Container(),
        color: Palette.yellow,
      ),
      const _PageInfos(
        num: 3,
        icon: ArbennIcons.search,
        content: SearchPage(),
        color: Palette.green,
      ),
      _PageInfos(
        num: 4,
        icon: ArbennIcons.user,
        content: ProfilePage(
          user: widget.currentUser,
          adminEvents: adminEvents,
        ),
        color: Palette.blue,
      ),
    ];
    _currentPageInfos = _pagesInfos[widget.startingPage];
  }

  Widget _buildNavBar(BuildContext context) {
    final List<Widget> buttons = _pagesInfos.map(
      (pageInfos) {
        Function() onPressed = pageInfos.num == 2
            ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventFormPage(),
                ))
            : () =>
                setState(() => _currentPageInfos = _pagesInfos[pageInfos.num]);
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
        child: Flex(direction: Axis.horizontal, children: buttons),
      ),
    );
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
              child: _currentPageInfos.content,
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
