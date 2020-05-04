import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/Pages/client_appointments/client_appointments.dart';
import 'package:cuthair/ui/Pages/client_home/client_home.dart';
import 'package:cuthair/ui/Pages/info/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'menu_presenter.dart';

class Menu extends StatefulWidget {
  User user;

  Menu(this.user, {HairDressing hairDressing});

  @override
  _menuState createState() => _menuState(user);
}

class _menuState extends State<Menu> implements MenuView {
  User user;
  MenuPresenter _presenter;
  int selectedItem = 1;
  int aux;

  _menuState(this.user);

  List<Widget> screens = [];

  void initState() {
    _presenter = MenuPresenter(this);
    _presenter.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return screens.length == 0
        ? SpinKitPulse(
            color: Color.fromRGBO(230, 73, 90, 1),
          )
        : Scaffold(
            body: screens[selectedItem],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Color.fromRGBO(230, 73, 90, 1),
                primaryColor: Color.fromRGBO(230, 73, 90, 1),
                textTheme: Theme.of(context).textTheme.copyWith(
                      caption: TextStyle(color: Colors.white),
                    ),
              ),
              child: BottomNavigationBar(
                  key: Key('navBar'),
                  backgroundColor: Colors.black,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.menu,
                        key : Key('menuIcon')
                      ),
                      title: Text(""),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                          key : Key('homeIcon')
                      ),
                      title: Text(""),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.account_circle,
                          key : Key('userInfoIcon')
                      ),
                      title: Text(""),
                    ),
                  ],
                  currentIndex: selectedItem,
                  onTap: showScreen),
            ),
          );
  }

  @override
  showScreen(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  @override
  goToClient() {
    setState(() {
      screens = [ClientAppointments(), ClientHome(), Info(user)];
    });
  }
}
