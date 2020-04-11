class Service {
  String tipo;
  String duracion;
  String precio;

  Service(this.tipo, this.duracion, this.precio);

  factory Service.fromMap(Map values, String tipo) {
    String duracion = values['duracion'];
    String precio = values['precio'];
    return Service(tipo, duracion, precio);
  }
}
