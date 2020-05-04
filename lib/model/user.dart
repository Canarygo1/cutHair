
class User{
  String phone;
  String surname;
  String name;
  String email;
  String uid;

  User(this.surname, this.name, this.email,
      this.phone,this.uid);

  factory User.fromMap(Map values,String uid) {
    String phone = values['Telefono'];
    String surname = values['Apellidos'];
    String name = values['Nombre'];
    String email = values['Email'];

    return User(surname, name, email, phone,uid);
  }

  Map<String, dynamic> toMap(){
    return{
      'name':name,
      'surname':surname,
      'email':email,
      'phone':phone,
      'uid':uid
    };
  }
}