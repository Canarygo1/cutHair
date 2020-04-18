import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/my_appointment.dart';

class ClientAppointmentsPresenter {
  MyAppointmentsView _view;
  RemoteRepository _remoteRepository;

  ClientAppointmentsPresenter(this._view, this._remoteRepository);

  init() async {
    try {
      List<MyAppointment> myAppointments = await _remoteRepository
          .getUserAppointments("BCEcwbhSYNVf68upkb8RQ9QHxdA2");
      await _view.showAppointments(myAppointments);
    }catch(e){
      print(e.toString());
    }
  }


  removeAppointment(MyAppointment appointment, int index){
    _remoteRepository.removeAppointment(appointment, index);
  }
}

abstract class MyAppointmentsView {
  showAppointments(List<MyAppointment> myAppointment);
}
