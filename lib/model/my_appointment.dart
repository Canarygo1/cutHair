class MyAppointment {
  String hairdressing;
  String hairdresser;
  String type;
  String price;
  String checkIn;
  String checkOut;

  MyAppointment(this.hairdressing, this.hairdresser, this.type, this.price,
      this.checkIn, this.checkOut);

  factory MyAppointment.fromMap(Map values){
    return MyAppointment(
        values["Peluqueria"], values['Peluquero'], values["Servicio"],
        values['Precio'], values["CheckIn"], values["CheckOut"]);
  }
}
