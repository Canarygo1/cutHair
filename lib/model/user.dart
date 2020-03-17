class User{
  String phone;
  String surname;
  String name;
  String email;
  int permission;


  User(this.surname, this.name, this.email,
      this.permission, this.phone);

  factory User.fromMap(Map values) {
    String phone = values['Telefono'];
    String surname = values['Apellidos'];
    String name = values['Nombre'];
    String email = values['Email'];
    int permission = values['Permisos'];
    return User(surname, name, email, permission, phone);
  }

}