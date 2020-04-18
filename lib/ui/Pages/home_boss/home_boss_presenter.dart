import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/employe.dart';

class HomeBossPresenter {
  HomeBossView _view;
  RemoteRepository _remoteRepository;

  HomeBossPresenter(this._view, this._remoteRepository);

  init() async {
    try{
      _view.showHairdresser(await _remoteRepository.getAllEmployes());
    }catch(e){
      _view.showButtonRecharge();
    }

  }
}

abstract class HomeBossView {
  showHairdresser(List<Employe> employes);
  showHairdresserEmpty(String error);
  showButtonRecharge();
}
