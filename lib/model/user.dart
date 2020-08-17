class User{
  String phone;
  String surname;
  String name;
  String email;
  String uid;
  String password;

  User(this.surname, this.name, this.email,
      this.phone,this.uid, this.password);

  factory User.fromMap(Map values,String uid) {
    String phone = values['Telefono'];
    String surname = values['Apellidos'];
    String name = values['Nombre'];
    String email = values['Email'];
    String password = values['Contraseña'];

    return User(surname, name, email, phone,uid, password);
  }

  Map<String, dynamic> toMap(){
    return{
      'name':name,
      'surname':surname,
      'email':email,
      'phone':phone,
      'uid':uid,
      'password':password,
    };
  }
}