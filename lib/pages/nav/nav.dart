import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/pages/nav/_nav_bar.dart';
import 'package:arbenn/pages/user/current_user_profile.dart';
import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../search/search_page.dart';
import '../calendar/calendar_page.dart';
import 'package:arbenn/pages/nav/_app_bar.dart';

class Nav extends StatefulWidget {
  final int startingPage;

  const Nav({
    super.key,
    this.startingPage = 0,
  });

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  final _pagesInfos = [
    PageInfos(
      number: 0,
      icon: AkarIcons.home,
      page: const HomePage(),
    ),
    PageInfos(
      number: 1,
      icon: AkarIcons.calendar,
      page: const CalendarPage(),
    ),
    PageInfos(
      number: 2,
      icon: AkarIcons.search,
      page: const SearchPage(),
    ),
    PageInfos(
      number: 3,
      icon: AkarIcons.person,
      page: const CurrentUserProfilePage(),
    ),
  ];
  late PageInfos _currentPageInfos;

  selectPage(int number) {
    setState(() {
      _currentPageInfos = _pagesInfos[number];
    });
  }

  @override
  void initState() {
    super.initState();
    _currentPageInfos = _pagesInfos[widget.startingPage];
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: Colors.white,
        child: SafeArea(
          top: _currentPageInfos.number != 3,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: _currentPageInfos.number == 3 ? null : appBar(context),
            bottomNavigationBar: NavBar(
              pages: _pagesInfos,
              currentPage: _currentPageInfos,
              onPressed: selectPage,
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: _currentPageInfos.page,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
