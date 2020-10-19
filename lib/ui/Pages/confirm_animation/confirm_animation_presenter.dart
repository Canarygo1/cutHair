import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConfirmAnimationPresenter{

  ConfirmAnimationView _view;
  RemoteRepository _remoteRepository;
  final storage = new FlutterSecureStorage();

  ConfirmAnimationPresenter(this._view, this._remoteRepository);

  init(Appointment appointment, String businessType, Service service, Business business) async {
    try {
      _view.modifyMaxPercentage(30);
      String accessToken = await storage.read(key: 'AccessToken');
      List<String> availability = await _remoteRepository.getDisponibility(accessToken,
          appointment.employeeId, businessType, appointment.checkIn, service.duration);
      _view.modifyMaxPercentage(75);
      String availabilityValue = appointment.checkIn.split(".")[0];
      if(availability.contains(availabilityValue)){
        bool salida;
        var params = createParams(appointment, business, service);
        if(business.useEmployees){
          salida = await _remoteRepository.insertAppointment(appointment, accessToken, params);
        }else{
          salida = await _remoteRepository.insertAppointmentPlace(appointment, accessToken, params);
        }
        _view.modifyMaxPercentage(100);
        if(salida == true){
          _view.correctInsert();
        }else{
          _view.incorrectInsert();
        }
      }else{
        throw ('Ya no esta disponible');
      }
    }catch(e){
      if (e == 'JWT error') {
        String refreshToken = await storage.read(key: 'RefreshToken');
        await GlobalMethods().generateNewAccessToken(refreshToken);
        init(appointment, businessType, service, business);
      }
      _view.modifyMaxPercentage(100);
      _view.incorrectInsert();
    }
  }

  createParams(Appointment appointment, Business business, Service service){
    String checkIn = appointment.checkIn.split(".")[0];
    String checkOut = appointment.checkOut.split(".")[0];
    var params;
    if(business.isServiceSelected == true){
      params = {
        "Precio": service.price,
        "CheckIn": checkIn,
        "CheckOut": checkOut,
        "EmployeeId": appointment.employeeId,
        "isAnonymous": "User",
        "ServiceId": appointment.serviceId,
      };
    }else{
      params = {
        "Precio": service.price,
        "CheckIn": checkIn,
        "CheckOut": checkOut,
        "isAnonymous": "User",
        "ServiceId": appointment.serviceId,
        "UserId": appointment.userId
      };
    }
    return params;
  }
}
abstract class ConfirmAnimationView{
  correctInsert();
  incorrectInsert();
  modifyMaxPercentage(double value);
}