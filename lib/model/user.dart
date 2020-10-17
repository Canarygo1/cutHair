class User {
  String phone;
  String surname;
  String name;
  String email;
  String id;
  bool penalizacion;
  int permission;

  User(this.surname, this.name, this.email, this.phone, this.id, this.permission, {this.penalizacion});

  factory User.fromMap(Map values) {
    String id = values['Id'];
    String phone = values['Telefono'];
    String surname = values['Apellidos'];
    String name = values['Nombre'];
    String email = values['Email'];
    int permission = values['Permisos'];
    bool penalizacion = values['Penalizacion'];

    return User(
        surname, name, email, phone, id, permission, penalizacion: penalizacion);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'email': email,
      'phone': phone,
      'id': id,
      'permission': permission
    };
  }

  @override
  String toString() {
    return 'User{phone: $phone, surname: $surname, name: $name, email: $email, id: $id, penalizacion: $penalizacion, permission: $permission}';
  }
}
