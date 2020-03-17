import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/remote_repository.dart';

import '../../model/hairDressing.dart';

class HomePagePresenter {
  HomeView _view;
  RemoteRepository _remoteRepository;


  HomePagePresenter(this._view, this._remoteRepository);

  init() async {
    print("dentro");
    _view.showList(await _remoteRepository.getAllHairdressing());
  }
}

abstract class HomeView {
  showList(List<HairDressing> hairDressing);
}
