import 'package:cuthair/data/remote/RemoteRepository.dart';

class ChooseHairDresserPresenter {
  ChooseHairDresserView _view;
  RemoteRepository _remoteRepository;

  ChooseHairDresserPresenter(this._view, this._remoteRepository);

  init() async {
    _view.showEmployes(await _remoteRepository.getAllEmployes());
  }
}

abstract class ChooseHairDresserView {
  showEmployes(List employes) {
  }
}
