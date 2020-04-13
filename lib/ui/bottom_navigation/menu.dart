import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/bottom_navigation/menu_presenter.dart';
import 'package:cuthair/ui/client_home/client_home.dart';
import 'package:cuthair/ui/detail/detail_screen.dart';
import 'package:cuthair/ui/hairdresser_home/hairdresser_home_screen.dart';
import 'package:cuthair/ui/home/home.dart';
import 'package:cuthair/ui/home_boss/home_boss.dart';
import 'package:cuthair/ui/info/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Menu extends StatefulWidget {
  User user;

  Menu(this.user,{HairDressing hairDressing});

  @override
  _menuState createState() => _menuState(user);
}

class _menuState extends State<Menu> implements MenuView{
  User user;
  RemoteRepository _remoteRepository;
  MenuPresenter _presenter;
  int selectedItem = 0;
  int aux;
  _menuState(this.user);
  List<Widget> screens = [];
  void initState() {
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    _presenter = MenuPresenter(_remoteRepository, user, this);
    _presenter.init();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return screens.length == 0 ? SpinKitPulse(
      color: Color.fromRGBO(230, 73, 90, 1),
    ):Scaffold(
        body: screens[selectedItem],
        bottomNavigationBar: new Theme(
            data: Theme.of(context).copyWith(
                // sets the background color of the `BottomNavigationBar`
                canvasColor: Color.fromRGBO(230, 73, 90, 1),
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Color.fromRGBO(230, 73, 90, 1),
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.white))),
            child: BottomNavigationBar(
                backgroundColor: Colors.black,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.menu,
                      ),
                      title: Text("")),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.add,
                      ),
                      title: Text("")),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.account_circle,
                      ),
                      title: Text("")),
                ],
                currentIndex: selectedItem,
                onTap: showScreen)));
  }

  @override
  showScreen(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  @override
  goToBoss(HairDressing hairDressing) {
    setState(() {
      screens = [HomeBoss(user),DetailScreen(hairDressing), Info(user)];
    });
    return null;
  }
  @override
  goToEmployee(HairDressing hairDressing) {
    setState(() {
      screens = [HairdreserHome(user), DetailScreen(hairDressing), Info(user)];
    });
    return null;
  }
  @override
  goToClient() {
    setState(() {
      screens = [ClienteHome(), Home(), Info(user)];
    });
    return null;
  }


}
