class Availability{
  var day;
  var disponibilidad;

  Availability(this.day, this.disponibilidad);

  factory Availability.fromMap(Map values, String uid) {
    String day = uid;
    String disponibilidad = values['disponibilidad'];
    return Availability(day, disponibilidad);
  }

}