class HairDressing {
  var uid;
  var name;
  var shortDirection;
  var direction;
  var type;
  var phoneNumber;
  var numeroFotos;
  var typeBusiness;

  HairDressing(this.name, this.shortDirection, this.direction, this.type,
      this.phoneNumber, this.numeroFotos, this.uid, this.typeBusiness);

  factory HairDressing.fromMap(Map values, String uid, String typeBusiness) {
    String name = values['NOMBRE'];
    String direction = values['Ubicacion'];
    int phoneNumber = values['Telefono'];
    String type = values['tipo'];
    String shortDirection = values['shortUbicacion'];
    int numeroFotos = values['Fotos'];
    return HairDressing(name, shortDirection, direction, type, phoneNumber, numeroFotos, uid, typeBusiness);
  }
}
