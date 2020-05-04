import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App', () {

    final loginButton = find.byValueKey('loginButton');
    final usernameTextField = find.byValueKey('loginTextField');
    final passwrodTextField = find.byValueKey('passwordTextField');
    final homeCard = find.byValueKey('homeCard');
    final detailList = find.text("Arreglo de barba");
    final selectedHairdresser = find.text("Maxi");
    final selectedDay = find.text("1");
    final selectedHour = find.text("7:40");

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
      await driver.tap(passwrodTextField);
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
  });
}