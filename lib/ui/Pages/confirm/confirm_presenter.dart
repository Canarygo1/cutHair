import 'package:cuthair/data/remote/remote_repository.dart';

class ConfirmPresenter{

  ConfirmView _view;
  RemoteRepository _remoteRepository;

  ConfirmPresenter(this._view, this._remoteRepository);

  init(String userUid) async {
    try {
      _view.showPenalize(await _remoteRepository.getUserPenalize(userUid));
    }catch(e){
      print(e.toString());
    }
  }
}

abstract class ConfirmView {
  showPenalize(bool penalize);
}
