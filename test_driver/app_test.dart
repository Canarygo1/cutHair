import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App', () {

    final loginButton = find.byValueKey('loginButton');
    final usernameTextField = find.byValueKey('loginTextField');
    final passwordTextField = find.byValueKey('passwordTextField');
    final homeCard = find.byValueKey('homeCard');
    final confirmButton = find.byValueKey('confirmButton');
    final backMenuButton = find.byValueKey('backMenuButton');
    final NavBar = find.byValueKey('navBar');
    final menuIcon = find.byValueKey('menuIcon');
    final initAppointmentText = find.byValueKey('initAppointment');
    final cancelDateDialog = find.byValueKey('yesDialogText');
    final cancelDateButton = find.byValueKey('cancelButton');
    final detailList = find.text("Arreglo de barba");
    final selectedHairdresser = find.text("Maxi");
    final selectedDay = find.text("4");
    final selectedHour = find.text("12:30");

    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('insert email', () async {
      await driver.tap(usernameTextField);
      await driver.enterText("domi.trivi2000@hotmail.com");
    });

    test('insert password', () async {
      await driver.tap(passwordTextField);
      await driver.enterText('1234qwer');
    });

    test('click login', () async {
      await driver.tap(loginButton);
    });

    test('click home', () async {
      await driver.tap(homeCard);
    });

    test('click selectService', () async {
      await driver.tap(detailList);
    });

    test('click hairdresser', () async {
      await driver.tap(selectedHairdresser);
    });

    test('click selectedDay', () async {
      await driver.tap(selectedDay);
    });

    test('click time', () async {
      await driver.tap(selectedHour);
    });

    test('click confirm date', () async {
      await driver.tap(confirmButton);
    });
    
    test('confirmation screen', () async{
      await driver.tap(backMenuButton);
    });

    test('change to menu screen', () async{
      await driver.tap(menuIcon);
    });

    test('cancel date',()async{
        await driver.tap(cancelDateButton);
        await driver.tap(cancelDateDialog);

    });
  });
}

