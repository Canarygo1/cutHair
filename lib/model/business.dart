class Business {
  var uid;
  var name;
  var shortDirection;
  var direction;
  var type;
  var phoneNumber;
  var numeroFotos;
  var typeBusiness;
  var maxPeople;
  int durationMeal;

  Business(this.name, this.shortDirection, this.direction, this.type,
      this.phoneNumber, this.numeroFotos, this.uid, this.typeBusiness, {this.maxPeople, this.durationMeal});

  factory Business.fromMap(Map values, String uid, String typeBusiness) {
    String name = values['NOMBRE'];
    String direction = values['Ubicacion'];
    int phoneNumber = values['Telefono'];
    String type = values['tipo'];
    String shortDirection = values['shortUbicacion'];
    int numeroFotos = values['Fotos'];
    if(typeBusiness == "Peluquerías"){
      return Business(name, shortDirection, direction, type, phoneNumber, numeroFotos, uid, typeBusiness);
    }else{
      int numberPeople = values['MaximoReserva'];
      int meal = int.parse(values["duracionComida"]);
      return Business(name, shortDirection, direction, type, phoneNumber, numeroFotos, uid, typeBusiness, maxPeople: numberPeople, durationMeal: meal);
    }
  }
}
