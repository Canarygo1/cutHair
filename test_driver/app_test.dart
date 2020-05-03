import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('login', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final buttonFinder = find.byValueKey('increment');

    FlutterDriver driver;

    Future <void> tap (SerializableFinder element) async {
      await driver.tap(element);
    }

    Future <void> type(SerializableFinder element, String text) async{
      await tap(element);
      await driver.enterText(text);
    }

    SerializableFinder findByValueKey(String text){
      return find.text(text);
    }

    Future <void> getText(SerializableFinder element) async {
      return driver.getText(element);
    }


    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('should login with valid credentials', () async {

      SerializableFinder emailInput = findByValueKey('emailText');
      SerializableFinder passwordInput = findByValueKey('passText');
      await tap(emailInput);
      await type(emailInput, 'domi.trivi2000@hotmail.com');
      await tap(passwordInput);
      await type(passwordInput, '1234qwer');
      SerializableFinder loginButton = findByValueKey('botonLogin');
      await tap(loginButton);

      print(driver.getText(loginButton));

    });


  });
}