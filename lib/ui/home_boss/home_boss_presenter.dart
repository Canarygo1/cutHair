import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/employe.dart';

class HomeBossPresenter {
  HomeBossView _view;
  RemoteRepository _remoteRepository;

  HomeBossPresenter(this._view, this._remoteRepository);

  init() async {
    _view.showHairdresser(await _remoteRepository.getAllEmployes());
  }
}

abstract class HomeBossView {
  showHairdresser(List<Employe> employes);
}
