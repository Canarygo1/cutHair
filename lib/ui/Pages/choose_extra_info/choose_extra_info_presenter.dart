import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/Place.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/employee.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChooseExtraInfoPresenter {
  ChooseHairDresserView _view;
  RemoteRepository _remoteRepository;
  final storage = new FlutterSecureStorage();

  ChooseExtraInfoPresenter(this._view, this._remoteRepository);

  init(Business business, String typeBusiness) async {
    try {
      String accessToken = await storage.read(key: 'AccessToken');
      if(business.useEmployees == true){
        List<Employee> employees = await _remoteRepository.getAllEmployes(business.id, accessToken);
        employees.sort((a, b) => a.order.compareTo(b.order));
        _view.showEmployes(employees);
      }else{
        List<Place> places = await _remoteRepository.getAllPLace(business.id, accessToken);
        _view.showPlaces(places);
      }
    } catch (e) {
      if (e == 'JWT error') {
        String refreshToken = await storage.read(key: 'RefreshToken');
        await GlobalMethods().generateNewAccessToken(refreshToken);
        await init(business, typeBusiness);
      }
    }
  }

  nextScreen() async {
      _view.goToCalendar();
  }
}

abstract class ChooseHairDresserView {
  showEmployes(List employes);
  showPlaces(List places);
  goToCalendar();
}