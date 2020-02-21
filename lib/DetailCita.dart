class DetailCita
{
  String peluquero;
  DateTime fechaCita;
  String horaCita;
  String tipoServicio;
  int duracionServicio;
  double precioServicio;

  DetailCita(this.tipoServicio, this.duracionServicio, this.precioServicio);



  String get nombrePeluquero {
    return peluquero;
  }

  void set nombrePeluquero(String nombre){
    this.peluquero = nombre;
  }

  DateTime get fecha {
    return fechaCita;
  }

  void set fecha(DateTime fecha){
    this.fechaCita = fecha;
  }

  String get hora {
    return horaCita;
  }

  void set hora(String hora){
    this.horaCita = hora;
  }

  String get tipo {
    return tipoServicio;
  }

  void set tipo(String tipo){
    this.tipoServicio = tipo;
  }

  int get duracion {
    return duracionServicio;
  }

  void set duracion(int duracion){
    this.duracionServicio = duracion;
  }

  double get precio {
    return precioServicio;
  }

  void set precio(double precio){
    this.precioServicio = precio;
  }

}