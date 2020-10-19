class Place {
  String id;
  String unity;
  String type;
  String businessId;

  Place(this.id, this.unity, this.type, this.businessId);

  @override
  String toString() {
    return 'Place{id: $id, unity: $unity, type: $type, businessId: $businessId}';
  }

  factory Place.fromMap(Map values) {
    String id = values['Precio'];
    String unity = values['Nombre'];
    String type = values['Duracion'];
    String businessId = values['Id'];
    return Place(id, unity, type, businessId);

  }
}
