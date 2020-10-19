class BusinessType {
  String id;
  String type;

  BusinessType(this.id, this.type);

  @override
  String toString() {
    return 'BusinessType{id: $id, type: $type}';
  }

  factory BusinessType.fromMap(Map data) {
    String id = data['Id'];
    String type = data['Tipo'];
    return BusinessType(id, type);
  }
}
