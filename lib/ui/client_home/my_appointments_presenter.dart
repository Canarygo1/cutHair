import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/my_appointment.dart';

class MyAppointmentsPresenter {
  MyAppointmentsView _view;
  RemoteRepository _remoteRepository;

  MyAppointmentsPresenter(this._view, this._remoteRepository);

  init() async {
    List<MyAppointment> myAppointments = await _remoteRepository.getUserAppointments("BCEcwbhSYNVf68upkb8RQ9QHxdA2");
    await _view.showAppointments(myAppointments);
  }
}

abstract class MyAppointmentsView {
  showAppointments(List<MyAppointment> myAppointment);
}
