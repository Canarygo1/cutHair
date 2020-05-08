import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';

class ChooseHairDresserPresenter {
  ChooseHairDresserView _view;
  RemoteRepository _remoteRepository;

  ChooseHairDresserPresenter(this._view, this._remoteRepository);

  init(String businessUid, String typeBusiness) async {
    _view.showEmployes(await _remoteRepository.getAllEmployes(businessUid, typeBusiness));
  }

  nextScreen(Appointment appointment) async {
      _view.goToCalendar();
  }
}

abstract class ChooseHairDresserView {
  showEmployes(List employes) {}
  goToCalendar();
}