import 'package:cuthair/model/Place.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/model/service.dart';

class Appointment {
  String id;
  String checkIn;
  String checkOut;
  String serviceId;
  String employeeId;
  String userId;
  String anonimoId;
  String businessId;
  String plazaCitaId;
  String price;
  Employee employee;
  Business business;
  Service service;
  Place place;

  Appointment(
      {this.checkIn,
      this.checkOut,
      this.serviceId,
      this.employeeId,
      this.userId,
      this.businessId,
      this.plazaCitaId,
      this.id,
      this.price,
      this.anonimoId,
      this.service,
      this.business,
      this.employee,
      this.place});

  @override
  String toString() {
    return 'Appointment{id: $id, checkIn: $checkIn, checkOut: $checkOut, serviceId: $serviceId, employeeId: $employeeId, userId: $userId, anonimoId: $anonimoId, businessId: $businessId, peopleReserve: $plazaCitaId, price: $price}';
  }

  factory Appointment.fromMap(Map values, bool isCompleted) {
    String id = values['Id'];
    String checkIn = values['CheckIn'];
    String checkOut = values['CheckOut'];
    String price = values['Precio'];
    String serviceId = values['ServicioCitaId'];
    String employeeId = values['EmpleadoCitaId'];
    String userId = values['UsuarioCitaId'];
    String anonimoId = values['AnonimoCitaId'];
    String plazaId = values['PlazaCitaId'];
    Employee employee;
    Business business;
    Service service;
    if(isCompleted){
      employee = Employee.fromMap(values['Empleados']);
      business = Business.fromMap(values['Empleados']["Negocios"]);
      service = Service.fromMap(values['ServicioCita']);
    }
    return Appointment(
        id: id,
        checkIn: checkIn,
        checkOut: checkOut,
        price: price,
        serviceId: serviceId,
        employeeId: employeeId,
        userId: userId,
        anonimoId: anonimoId,
        plazaCitaId: plazaId,
        business: business,
        service: service,
        employee: employee);
  }
}
