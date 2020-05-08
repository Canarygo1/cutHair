class MyAppointment {
  String uid;
  String businessName;
  String employeeName;
  String type;
  String price;
  String checkIn;
  String checkOut;
  String direction;
  String typeBusiness;

  MyAppointment(this.uid, this.businessName, this.employeeName, this.type, this.price,
      this.checkIn, this.checkOut, this.direction, this.typeBusiness);

  factory MyAppointment.fromMap(Map values, String uid, String typeBusiness){
    return MyAppointment(uid,
        values["Negocio"], values['Empleado'], values["Servicio"],
        values['Precio'], values["CheckIn"], values["CheckOut"], values["Direccion"], typeBusiness);
  }
}
