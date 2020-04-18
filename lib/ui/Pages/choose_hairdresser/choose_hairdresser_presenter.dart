import 'package:cuthair/data/remote/remote_repository.dart';

class ChooseHairDresserPresenter {
  ChooseHairDresserView _view;
  RemoteRepository _remoteRepository;

  ChooseHairDresserPresenter(this._view, this._remoteRepository);

  init() async {
    try {
      _view.showEmployes(await _remoteRepository.getAllEmployes());
    }catch(e){
      print(e.toString());
    }
  }
}

abstract class ChooseHairDresserView {
  showEmployes(List employes) {}
  goToNextScreen(int index);
}
// User user = DBProvider.db.getUser();