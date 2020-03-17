class User{
  String _phone;
  String _surname;
  String _name;
  String _email;
  String _tipo;
  int _permission;


  User();

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get surname => _surname;

  int get permission => _permission;

  set permission(int value) {
    _permission = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  set surname(String value) {
    _surname = value;
  }

}