import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/user.dart';

class ChooseHairDresserPresenter {
  ChooseHairDresserView _view;
  RemoteRepository _remoteRepository;

  ChooseHairDresserPresenter(this._view, this._remoteRepository);

  init() async {
    _view.showEmployes(await _remoteRepository.getAllEmployes());
  }

  nextScreen(Appointment appointment) async {
    await DBProvider.db.getUser();
    User user  = DBProvider.users[0];
    print(user.uid);
    print(user.permission);
    if(user.permission == 1){
      _view.goToTimeSelection();
    }
    else if(user.permission == 2){
      _view.goToTimeSelection();
    }
    else{
      _view.goToCalendar();
    }
  }
}

abstract class ChooseHairDresserView {
  showEmployes(List employes) {}
  goToCalendar();
  goToTimeSelection();
}
// User user = DBProvider.db.getUser();