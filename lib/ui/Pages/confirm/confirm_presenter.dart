import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/Place.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/employee.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConfirmPresenter{

  ConfirmView _view;
  RemoteRepository _remoteRepository;
  final storage = new FlutterSecureStorage();

  ConfirmPresenter(this._view, this._remoteRepository);

  init(Appointment appointment, Business business) async {
    try {
      String accessToken = await storage.read(key: 'AccessToken');
      bool penalization = await _remoteRepository.getUserPenalization(accessToken, DBProvider.users[0].id);
      _view.showPenalize(penalization);
      if(business.useEmployees == true){
        Employee employee = await _remoteRepository.getEmployeeById(accessToken, appointment.employeeId);
        _view.viewEmployee(employee);
      }else{
        Place place = await _remoteRepository.getPlaceById(accessToken, appointment.plazaCitaId);
        _view.viewPlaza(place);
      }
    } catch (e) {
      print(e);
      if (e == 'JWT error') {
        String refreshToken = await storage.read(key: 'RefreshToken');
        await GlobalMethods().generateNewAccessToken(refreshToken);
        await init(appointment, business);
      }
    }
  }
}

abstract class ConfirmView {
  showPenalize(bool penalize);
  viewEmployee(Employee result);
  viewPlaza(place);
}
