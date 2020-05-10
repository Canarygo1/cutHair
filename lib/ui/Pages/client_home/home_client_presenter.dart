import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/business.dart';

class HomeClientPresenter {
  HomeView _view;
  RemoteRepository _remoteRepository;
  Map<String, List<Business>> businessMap = Map();
  HomeClientPresenter(this._view, this._remoteRepository);

  init() async {
    try {
      List<String> businessType = await _remoteRepository.getBusiness();
      await _view.showBusiness(businessType);
      await chargeBusiness(businessType);
      _view.changeLoading();
    } catch (e) {
      print(e.toString());
    }
  }

  chargeBusiness(List<String> businesses) async {
    for (int i = 0; i < businesses.length; i++) {
      businessMap.addAll(await _remoteRepository.getAllBusiness(businesses[i]));
    }
    _view.showList(businessMap);
  }
}
abstract class HomeView {
  showList(Map<String, List<Business>> mapBusinesses);
  showBusiness(List<String> business);
  changeLoading();
}

