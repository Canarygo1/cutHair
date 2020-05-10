class Service {
  String type;
  String duration;
  String price;
  String description;

  Service(this.type,this.price, {this.description, this.duration});

  factory Service.fromMap(Map values, String typeBusiness) {
    String price = values['precio'];
    String type = values['nombre'];

    if(typeBusiness == "Peluquerias"){
      String duration = values['duracion'];
      return Service(type, price, duration: duration);
    }else{
      String description = values['descripcion'];
      return Service(type, price, description: description);
    }
  }
}
