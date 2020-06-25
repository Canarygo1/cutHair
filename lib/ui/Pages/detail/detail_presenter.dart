import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/business.dart';

class DetailPresenter {
  DetailView _view;
  RemoteRepository _remoteRepository;

  DetailPresenter(this._view, this._remoteRepository);

  init(Business business) async {
    if (business.typeBusiness != "Playas")
      _view.showServices(await _remoteRepository.getAllServices(
          business.uid, business.typeBusiness));
    _view.showImages(await _remoteRepository.getAllImages(business));
  }
}

abstract class DetailView {
  showServices(List services);
  showImages(List images);
}
