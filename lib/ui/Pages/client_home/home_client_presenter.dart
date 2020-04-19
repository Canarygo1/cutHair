import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/hairDressing.dart';

class HomeClientPresenter {
  HomeView _view;
  RemoteRepository _remoteRepository;


  HomeClientPresenter(this._view, this._remoteRepository);

  init() async {
    try {
      _view.showList(await _remoteRepository.getAllHairdressing());
    }catch(e){
      print(e.toString());
    }
  }
}

abstract class HomeView {
  showList(List<HairDressing> hairDressing);
}
