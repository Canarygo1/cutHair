import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:cuthair/model/appointment.dart';

class ChooseDatePresenter {
  ChooseDateView _view;
  ApiRemoteRepository _remoteRepository;

  ChooseDatePresenter(this._view, this._remoteRepository);

  init(Appointment appointment, String date) async {
    try {
      if (appointment.business.typeBusiness == "Peluquerías") {
        List availability = await _remoteRepository.getHairDressingAvailability(
            appointment.service.duration.toString(), appointment.employee.name, date, appointment.business.uid);

        _view.showAvailability(availability);
      }else if(appointment.business.typeBusiness == "Restaurantes"){
        List availability = await _remoteRepository.getRestaurantAvailability(
            appointment.business.durationMeal.toString(), appointment.numberPersons, date, appointment.business.uid);

        _view.showAvailability(availability);
      }else{
        List availability = await _remoteRepository.getBeachAvailability(
            appointment.business.durationMeal.toString(), appointment.numberPersons, date, appointment.business.uid);

        _view.showAvailability(availability);
      }
    } catch (e) {
      _view.emptyAvailability();
    }
  }
}

abstract class ChooseDateView {
  showAvailability(List<String> availability);
  emptyAvailability();
}
