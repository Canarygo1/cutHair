import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/employee.dart';

class ChooseHairDresserPresenter {
  ChooseHairDresserView _view;
  RemoteRepository _remoteRepository;

  ChooseHairDresserPresenter(this._view, this._remoteRepository);

  init(String businessUid, String typeBusiness) async {
    List<Employee> employees = await _remoteRepository.getAllEmployes(businessUid, typeBusiness);
    employees.sort((a, b) => a.order.compareTo(b.order));

    _view.showEmployes(employees);
  }

  nextScreen(Appointment appointment) async {
      _view.goToCalendar();
  }
}

abstract class ChooseHairDresserView {
  showEmployes(List employes) {}
  goToCalendar();
}