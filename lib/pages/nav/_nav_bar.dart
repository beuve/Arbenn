import 'package:arbenn/components/buttons.dart';
import 'package:flutter/material.dart';

class PageInfos {
  Widget page;
  int number;
  IconData icon;

  PageInfos({
    required this.page,
    required this.number,
    required this.icon,
  });
}

class NavBar extends StatelessWidget {
  final PageInfos currentPage;
  final List<PageInfos> pages;
  final Function(int) onPressed;

  const NavBar({
    super.key,
    required this.currentPage,
    required this.pages,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = pages.map(
      (pageInfos) {
        return NavButton(
          icon: pageInfos.icon,
          isActive: pageInfos.number == currentPage.number,
          onPressed: () => onPressed(pageInfos.number),
        );
      },
    ).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 50,
            blurRadius: 500,
            offset: const Offset(0, -15), // changes position of shadow
          ),
          const BoxShadow(
            color: Colors.white,
            spreadRadius: 10,
            offset: Offset(0, 30), // changes position of shadow
          )
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(children: buttons),
    );
  }
}
