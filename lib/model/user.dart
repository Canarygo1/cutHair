class User{
  String phone;
  String surname;
  String name;
  String email;
  int permission;
  String uid;

  User(this.surname, this.name, this.email,
      this.permission, this.phone,this.uid);

  factory User.fromMap(Map values,String uid) {
    String phone = values['Telefono'];
    String surname = values['Apellidos'];
    String name = values['Nombre'];
    String email = values['Email'];
    int permission = values['Permisos'];
    return User(surname, name, email, permission, phone,uid);
  }

  Map<String, dynamic> toMap(){
    return{
      'name':name,
      'surname':surname,
      'email':email,
      'phone':phone,
      'permission':permission,
      'uid':uid
    };
  }




}