class ImageBusiness {
  String id;
  String url;
  String negocioFotoId;
  String empladoFotoId;
  String type;

  @override
  String toString() {
    return 'ImageBusiness{id: $id, url: $url, type: $type}';
  }

  ImageBusiness(this.id, this.url, this.type, {this.negocioFotoId, this.empladoFotoId});

  factory ImageBusiness.fromMap(Map data) {
    String id = data['Id'];
    String url = data['Url'];
    String type = data['Tipo'];
    if (data['NegocioFotoId'] == null) {
      String empladoFotoId = data['EmpladoFotoId'];
      return ImageBusiness(id, url, type, empladoFotoId: empladoFotoId);
    } else {
      String negocioFotoId = data['NegocioFotoId'];
      return ImageBusiness(id, url, type, empladoFotoId: negocioFotoId);
    }
  }
}
