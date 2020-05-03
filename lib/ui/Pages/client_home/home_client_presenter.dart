import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/hairDressing.dart';

class HomeClientPresenter {
  HomeView _view;
  RemoteRepository _remoteRepository;

  HomeClientPresenter(this._view, this._remoteRepository);

  init() async {
    try {
      _view.showBusiness(await _remoteRepository.getBusiness());
      await _view.chargeBusiness();
    } catch (e) {
      print(e.toString());
    }
  }

  getBusiness(String business) async {
    try {
      await _view.showList(await _remoteRepository.getAllBusiness(business));
    } catch (e) {
      print(e.toString());
    }
  }
}

abstract class HomeView {
  showList(Map<String, List<HairDressing>> hairDressing);
  showBusiness(List<String> business);
  chargeBusiness();
}
