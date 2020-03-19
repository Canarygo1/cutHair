import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/client_home/client_home.dart';
import 'package:cuthair/ui/hairdresser_home/hairdresser_home_screen.dart';
import 'package:cuthair/ui/home/home.dart';
import 'package:cuthair/ui/home_boss/home_boss.dart';
import 'package:cuthair/ui/info/info.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  int aux;
  User user;
  Menu(this.aux, this.user);

  @override
  _menuState createState() => _menuState(aux, user);
}

class _menuState extends State<Menu>{
  User user;
  int selectedItem = 0;
  int aux;
  _menuState(this.aux, this.user);

  List<Widget> screens;

  void initState() {
    super.initState();
    if(aux == 1)screens = [HomeBoss(user), Home(), Info(user)];
    else if(aux == 2)screens = [HairdreserHome(user), Home(), Info(user)];
    else screens = [ClienteHome(), Home(), Info(user)];
  }

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
                title: Text("")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                title: Text("")),
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
