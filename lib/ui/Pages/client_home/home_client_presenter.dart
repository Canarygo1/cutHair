import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/hairDressing.dart';

class HomeClientPresenter {
  HomeView _view;
  RemoteRepository _remoteRepository;


  HomeClientPresenter(this._view, this._remoteRepository);

  init() async {
    _view.showList(await _remoteRepository.getAllHairdressing());
  }
}

abstract class HomeView {
  showList(List<HairDressing> hairDressing);
}
