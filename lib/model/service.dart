class Service {
  String id;
  String name;
  String duration;
  String price;
  String businessServiceId;

  @override
  String toString() {
    return 'Service{id: $id, name: $name, duration: $duration, price: $price, negocioServicioId: $businessServiceId}';
  }

  Service(this.id, this.name, this.duration, this.price,
      this.businessServiceId);

  factory Service.fromMap(Map values) {
    String price = values['Precio'];
    String name = values['Nombre'];
    String duration = values['Duracion'];
    String id = values['Id'];
    String businessServiceId = values['NegocioServicioId'];
    return Service(id, name, duration, price, businessServiceId);

  }
}
