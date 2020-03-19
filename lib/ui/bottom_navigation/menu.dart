import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/client_home/client_home.dart';
import 'package:cuthair/ui/hairdresser_home/hairdresser_home_screen.dart';
import 'package:cuthair/ui/home/home.dart';
import 'package:cuthair/ui/home_boss/home_boss.dart';
import 'package:cuthair/ui/info/info.dart';
import 'package:cuthair/ui/info/info_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  RemoteRepository _remoteRepository;
  InfoPagePresenter presenter;
  final FirebaseAuth auth = FirebaseAuth.instance;
  int selectedItem = 0;
  int aux;
  _menuState(this.aux, this.user);

  List<Widget> screens;

  void initState() {
    super.initState();
    if(aux == 0)screens = [HomeBoss(), Home(), Info(user)];
    else if(aux == 1)screens = [HairdreserHome(), Home(), Info(user)];
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
