import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String phone;
  String surname;
  String name;
  String email;
  int permission;
  String uid;
  String hairdressingUid = " ";

  User(this.surname, this.name, this.email,
      this.permission, this.phone,this.uid,{this.hairdressingUid});

  factory User.fromMap(Map values,String uid) {
    String phone = values['Telefono'];
    String surname = values['Apellidos'];
    String name = values['Nombre'];
    String email = values['Email'];
    int permission = values['Permisos'];

    if(permission != 3){
      DocumentReference documentReference = values["Ref"];
      String hairdressingUid = documentReference.documentID;
      return User(surname, name, email, permission, phone,uid,hairdressingUid: hairdressingUid);
    }
    return User(surname, name, email, permission, phone,uid);
  }

  Map<String, dynamic> toMap(){
    return{
      'name':name,
      'surname':surname,
      'email':email,
      'phone':phone,
      'permission':permission,
      'uid':uid,
      'hairdresserUid':hairdressingUid
    };
  }
}