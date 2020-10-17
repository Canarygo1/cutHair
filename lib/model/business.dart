import 'package:cuthair/model/image_business.dart';
import 'package:flutter/material.dart';

class Business {
  String id;
  String name;
  String typeId;
  String phoneNumber;
  String direction;
  String shortDirection;
  String type;
  bool useCheckout;
  bool useEmployees;
  String maxPerson;
  bool isServiceSelected;

  Widget widget;
  List<ImageBusiness> images;

  Business(
      this.id,
      this.name,
      this.typeId,
      this.phoneNumber,
      this.direction,
      this.shortDirection,
      this.type,
      this.useCheckout,
      this.useEmployees,
      this.maxPerson,
      this.isServiceSelected);

  factory Business.fromMap(Map values) {
    String id = values['Id'];
    String name = values['Nombre'];
    String typeId = values['TipoNegocioId'];
    String phoneNumber = values['Telefono'];
    String direction = values['Ubicacion'];
    String shortDirection = values['shortUbicacion'];
    String type = values['Tipo'];
    bool useCheckout = values['UsaCheckOut'];
    bool useEmployees = values['UsaEmpleados'];
    String maxPerson = values['MaxPersonas'];
    bool isServiceSelected = values['isServiceSelectable'];
    return Business(id, name, typeId, phoneNumber, direction, shortDirection,
        type, useCheckout, useEmployees, maxPerson, isServiceSelected);
  }

  @override
  String toString() {
    return 'Business{id: $id, name: $name, typeId: $typeId, phoneNumber: $phoneNumber, direction: $direction, shortDirection: $shortDirection, type: $type, useCheckout: $useCheckout, useEmployees: $useEmployees, maxPerson: $maxPerson, isServiceSelected: $isServiceSelected, widget: $widget, images: $images}';
  }
}
