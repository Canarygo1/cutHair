import 'package:cuthair/ui/detail/detail_screen.dart';
import 'package:cuthair/ui/home/home.dart';
import 'package:cuthair/ui/home_boss/home_boss.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _menuState createState() => _menuState();
}

class _menuState extends State<Menu>{

  List<Widget> screens;

  void initState() {
    super.initState();
    screens = [Home(),  HomeBoss(), DetailScreen()];
  }

  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[selectedItem],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                title: Text("")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                title: Text("prueba")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                title: Text("prueba")),
          ],
          onTap: showScreen,
          currentIndex: selectedItem,
        ));
  }

  @override
  showScreen(int index) {
    setState(() {
      selectedItem = index;
    });
  }
}