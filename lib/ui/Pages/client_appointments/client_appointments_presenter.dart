import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/my_appointment.dart';

class ClientAppointmentsPresenter {
  MyAppointmentsView _view;
  RemoteRepository _remoteRepository;

  ClientAppointmentsPresenter(this._view, this._remoteRepository);

  init(String userUid) async {
    try {
       _view.showAppointments(await _remoteRepository
           .getUserAppointments(userUid));
    }catch(e){
      _view.emptyAppointment();
    }
  }

  removeAppointment(MyAppointment appointment, int index, String userUid) async {
    try{
      await _remoteRepository.removeAppointment(appointment, index);
      _view.showAppointments(await _remoteRepository
          .getUserAppointments(userUid));
    }catch(Exception){
      _view.emptyAppointment();
    }

  }
}

abstract class MyAppointmentsView {
  showAppointments(List<MyAppointment> myAppointment);
  emptyAppointment();
}
