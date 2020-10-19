import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChooseDatePresenter {
  ChooseDateView _view;
  RemoteRepository _remoteRepository;
  final storage = new FlutterSecureStorage();

  ChooseDatePresenter(this._view, this._remoteRepository);

  init(Appointment appointment, DateTime date, String businessType,
      Service service, Business business) async {
    try {
      String accessToken = await storage.read(key: 'AccessToken');
      String id = business.useEmployees == true ? appointment.employeeId : appointment.plazaCitaId;
      List<String> availability = await _remoteRepository.getDisponibility(accessToken,
          id, businessType, date.toString(), service.duration);
      _view.showAvailability(availability);
    } catch (e) {
      if (e == 'JWT error') {
        String refreshToken = await storage.read(key: 'RefreshToken');
        await GlobalMethods().generateNewAccessToken(refreshToken);
        init(appointment, date, businessType, service, business);
      }
      _view.emptyAvailability();
    }
  }

  pressInOption(DateTime date, Appointment appointment, Service service) {
    DateTime checkOut =
        date.add(Duration(minutes: int.parse(service.duration)));
    appointment.checkIn = date.toString();
    appointment.checkOut = checkOut.toString();
    this._view.goToNewScreen(appointment);
  }
}

abstract class ChooseDateView {
  showAvailability(List<String> availability);

  goToNewScreen(Appointment value);

  emptyAvailability();
}
