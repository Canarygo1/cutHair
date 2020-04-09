
import 'package:cuthair/data/remote/remote_repository.dart';

class DetailPresenter {
  DetailView _view;
  RemoteRepository _remoteRepository;

  DetailPresenter(this._view, this._remoteRepository);

  init() async {
    _view.showServices(await _remoteRepository.getAllServices());
  }
}

abstract class DetailView {
  showServices(List servicios);
}
