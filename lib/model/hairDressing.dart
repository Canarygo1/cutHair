class HairDressing {
  var name;
  var shortDirection;
  var direction;
  var type;
  var phoneNumber;


  HairDressing(this.name, this.shortDirection, this.direction, this.type,
      this.phoneNumber);

  factory HairDressing.fromMap(Map values) {
    String name = values['NOMBRE'];
    String direction = values['Ubicacion'];
    int phoneNumber = values['Telefono'];
    String type = values['tipo'];
    String shortDirection = values['shortUbicacion'];
    return HairDressing(name, shortDirection, direction, type, phoneNumber);
  }
}
