import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/hairDressing.dart';

class DetailPresenter {
  DetailView _view;
  RemoteRepository _remoteRepository;

  DetailPresenter(this._view, this._remoteRepository);

  init(HairDressing hairDressing) async {
    try {
      _view.showServices(await _remoteRepository.getAllServices(hairDressing.uid, hairDressing.typeBusiness));
      _view.showImages(await _remoteRepository.getAllImages(hairDressing));
    }catch(e){
      print(e.toString());
    }
  }
}

abstract class DetailView {
  showServices(List servicios);

  showImages(List imagenes);

  makecall(String number);
}

