import 'package:flutter/cupertino.dart';

class Employee {
  String id;
  String name;
  String surname;
  String email;
  int permission;
  String phoneNumber;
  String order;
  String businessId;
  Widget widget;

  Employee(this.id, this.name, this.surname, this.email, this.permission,
      this.phoneNumber, this.order, this.businessId);

  @override
  String toString() {
    return 'Employee{id: $id, name: $name, surname: $surname, email: $email, permission: $permission, phoneNumber: $phoneNumber, order: $order, businessId: $businessId}';
  }

  factory Employee.fromMap(Map values) {
    String id = values['Id'];
    String name = values['Nombre'];
    String surname = values['Apellidos'];
    String email = values['Email'];
    int permission = values['Permisos'];
    String phoneNumber = values['Telefono'];
    String order = values['Orden'];
    String businessId = values['NegocioEmpleadoId'];
    return Employee(
        id, name, surname, email, permission, phoneNumber, order, businessId);
  }
}
