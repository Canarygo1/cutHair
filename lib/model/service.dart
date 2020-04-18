class Service {
  String type;
  String duration;
  String price;

  Service(this.type, this.duration, this.price);

  factory Service.fromMap(Map values) {
    String duration = values['duracion'];
    String price = values['precio'];
    String type = values['nombre'];
    return Service(type, duration, price);
  }
}
