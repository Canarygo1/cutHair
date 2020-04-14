import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/user.dart';

class ChooseHairDresserPresenter {
  ChooseHairDresserView _view;
  RemoteRepository _remoteRepository;

  ChooseHairDresserPresenter(this._view, this._remoteRepository);

  init() async {
    _view.showEmployes(await _remoteRepository.getAllEmployes());
  }

  nextScreen()async{
    await DBProvider.db.getUser();

    User user  = DBProvider.users[0];

    print(user.toString());
  }
}

abstract class ChooseHairDresserView {
  showEmployes(List employes) {}
  goToNextScreen(int index);
}
// User user = DBProvider.db.getUser();