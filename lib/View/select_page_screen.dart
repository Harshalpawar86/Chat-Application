import 'package:chat_app/View/chat_list_screen.dart';
import 'package:chat_app/View/edit_profile.dart';
import 'package:flutter/material.dart';
import "package:curved_navigation_bar/curved_navigation_bar.dart";

class SelectPageScreen extends StatefulWidget {
  const SelectPageScreen({super.key});

  @override
  State<SelectPageScreen> createState() => _SelectPageScreenState();
}

class _SelectPageScreenState extends State<SelectPageScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavigationBar(
            animationDuration: const Duration(milliseconds: 300),
            onTap: (selectedIndex) {
              currentIndex = selectedIndex;
              setState(() {});
            },
            height: 55,
            color: const Color.fromRGBO(191, 113, 247, 1),
            backgroundColor: Colors.transparent,
            items: [
              const Icon(
                Icons.home,
                color: Colors.white,
              ),
              const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ]),
        body: getSelectedPage(index: currentIndex));
  }

  Widget getSelectedPage({required int index}) {
    if (index == 0) {
      return const ChatListScreen();
    } else {
      return EditProfile();
    }
  }
}
