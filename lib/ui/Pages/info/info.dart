import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/components.dart';
import 'package:components/others_components/confirm_dialog.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/Pages/contribuyers/contribuyer_screen.dart';
import 'package:cuthair/ui/Pages/info/info_presenter.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:cuthair/ui/Pages/reset_password/reset_password_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  User user;

  Info(this.user);

  @override
  _InfoScreenState createState() => _InfoScreenState(user);
}

class _InfoScreenState extends State<Info> implements InfoView {
  User user;
  Widget screen;
  double HEIGHT;
  double WIDHT;
  String error = "";
  ConfirmDialog confirmDialog;
  var nameTextfield = TextEditingController();
  var surNameTextfield = TextEditingController();
  var emailTextfield = TextEditingController();
  var passwordTextField = TextEditingController();
  InfoPagePresenter presenter;
  RemoteRepository remoteRepository;
  bool errorColor = false;
  Timer timer;
  bool changes = false;

  _InfoScreenState(this.user);

  GlobalMethods global = GlobalMethods();

  @override
  void initState() {
    remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = InfoPagePresenter(this, remoteRepository);
    nameTextfield.text = DBProvider.users[0].name;
    surNameTextfield.text = DBProvider.users[0].surname;
    emailTextfield.text = DBProvider.users[0].email;
  }

  @override
  void deactivate() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    global.context = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 73, 90, 1),
        title: Components.largeText("Mis datos"),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            onTap: logOut,
            child: Padding(
              padding: EdgeInsets.only(right: WIDHT * 0.05),
              child: Icon(
                Icons.exit_to_app,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Image.asset("assets/images/userInfo.png"),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: WIDHT * 0.101),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Components.mediumText(
                    "Teléfono:",
                    color: Color.fromRGBO(230, 73, 90, 1),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: WIDHT * 0.101, top: 10.0, bottom: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Components.mediumText(
                        DBProvider.users[0].phone,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: WIDHT * 0.089),
                    child: Components.alertCard(
                      Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 22.0,
                      ),
                      Expanded(child: Components.smallText("No se Permite cambiar")),
                      HEIGHT * 0.033,
                      WIDHT * 0.4,
                      color: Color.fromRGBO(230, 73, 90, 1),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                child: Divider(
                  height: 1.0,
                  color: Colors.white,
                  indent: WIDHT * 0.101,
                  endIndent: WIDHT * 0.089,
                  thickness: 0.5,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: WIDHT * 0.101),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Components.mediumText(
                    "Nombre:",
                    color: Color.fromRGBO(230, 73, 90, 1),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child:
                    textFieldWidget(nameTextfield, TextInputType.text, "Name"),
              ),
              Padding(
                padding: EdgeInsets.only(left: WIDHT * 0.101),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Components.mediumText(
                    "Apellidos:",
                    color: Color.fromRGBO(230, 73, 90, 1),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: textFieldWidget(
                    surNameTextfield, TextInputType.text, "Apellidos"),
              ),
              Padding(
                padding: EdgeInsets.only(left: WIDHT * 0.101),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Components.mediumText(
                    "Email:",
                    color: Color.fromRGBO(230, 73, 90, 1),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: textFieldWidget(
                    emailTextfield, TextInputType.emailAddress, "Email"),
              ),
              error.length == 0
                  ? Container()
                  : Container(
                      child: Components.errorText(error,
                          color: errorColor == true
                              ? Color.fromRGBO(26, 200, 146, 1)
                              : Color.fromRGBO(230, 73, 90, 1)),
                    ),
              changes == true
                  ? Components.smallButton(() => dialogUpdate(),
                      Components.largeText("Guardar cambios"),
                      width: WIDHT * 0.85,
                      color: Color.fromRGBO(230, 73, 90, 1))
                  : Container(),
              Components.smallButton(() => functionResetPassword(),
                  Components.largeText("Cambiar contraseña"),
                  width: WIDHT * 0.85, color: Color.fromRGBO(230, 73, 90, 1)),
              bottomElements(),
            ]),
      ),
    );
  }

  Widget textFieldWidget(controller, textType, hintText,
      {obscureText = false, topPadding = 0.0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          WIDHT * 0.101, topPadding, WIDHT * 0.089, HEIGHT * 0.027),
      child: Components.textFieldPredefine(
        controller,
        textType,
        InputDecoration(
          hintText: hintText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: WIDHT * 0.003),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: WIDHT * 0.003),
          ),
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
        onchangeFunction: (content) {
          String text;
          if (controller == nameTextfield) {
            text = DBProvider.users[0].name;
          } else if (controller == surNameTextfield) {
            text = DBProvider.users[0].surname;
          } else {
            text = DBProvider.users[0].email;
          }
          content != text
              ? {
                  this.setState(() {
                    changes = true;
                  })
                }
              : {
                  this.setState(() {
                    changes = false;
                  })
                };
        },
        obscureText: obscureText,
      ),
    );
  }

  dialogUpdate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        confirmDialog = Components.confirmDialog(
          Column(
            children: <Widget>[
              Components.mediumText("Introduzca la contraseña para continuar"),
              textFieldWidget(
                  passwordTextField, TextInputType.text, "Contraseña",
                  obscureText: true),
            ],
          ),
          () => {},
          functionSimple: () => updateData(passwordTextField.text),
          textSimple: "Continuar",
          multiOptions: true,
        );
        return confirmDialog;
      },
    );
  }

  updateData(String password) {
    if (nameTextfield.text != DBProvider.users[0].name ||
        surNameTextfield.text != DBProvider.users[0].surname ||
        emailTextfield.text.toLowerCase() !=
            DBProvider.users[0].email.toLowerCase()) {
      Map<String, String> data = Map();
      data.putIfAbsent("Nombre", () => nameTextfield.text);
      data.putIfAbsent("Apellidos", () => surNameTextfield.text);
      data.putIfAbsent("Email", () => emailTextfield.text.toLowerCase());
      presenter.updateData(data, DBProvider.users[0].uid, password);
    }
  }

  Widget bottomElements() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch('https://pruebafirebase-44f30.web.app/');
                      },
                    text: " Política de Privacidad.",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 12)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        GlobalMethods().pushPage(context, contribuyer_screen());
                      },
                    text: " Lista de contribuidores",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 12)),
              ],
            ),
          ),
          Center(
              child: Components.smallText(
            "Resérvalo © 2020",
            boolText: FontWeight.normal,
          )),
          Center(child: Components.smallText("@Reservaloapp"))
        ],
      ),
    );
  }

  functionResetPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        confirmDialog = Components.confirmDialog(
          Components.mediumText("Seguro que quiere cambiar la contraseña de: " +
              DBProvider.users[0].email),
          () => {
            changePassword(),
            GlobalMethods().popPage(confirmDialog.context)
          },
        );
        return confirmDialog;
      },
    );
  }

  Future<void> logOut() async {
    await DBProvider.db.delete();
    screen = Login();
    await FirebaseAuth.instance.signOut();
    Timer(Duration(seconds: 1), changeScreen);
  }

  changePassword() async {
    ConnectionChecked.checkInternetConnectivity(context);
    ResetPasswordCode(DBProvider.users[0].email).changePassword();
    setState(() {
      error = 'Se ha enviado un correo a dicha direccion email';
    });
    await FirebaseAuth.instance.signOut();
    DBProvider.db.delete();
    Timer(Duration(seconds: 2),
        () => GlobalMethods().pushAndReplacement(context, Login()));
  }

  changeScreen() {
    GlobalMethods().pushAndReplacement(context, screen);
  }

  @override
  showUpdate(bool correct) {
    if (mounted) {
      setState(() {
        correct == true
            ? {error = "Datos guardados de forma correcta", errorColor = true}
            : {
                error = "Ha ocurrido un error, pruebe de nuevo",
                errorColor = false
              };
        changes = false;
        nameTextfield.text = DBProvider.users[0].name;
        surNameTextfield.text = DBProvider.users[0].surname;
        emailTextfield.text = DBProvider.users[0].email;
      });
      timer = Timer(
          Duration(seconds: 2),
          () => {
                this.setState(() {
                  errorColor = false;
                  error = "";
                })
              });
    }
  }
}
