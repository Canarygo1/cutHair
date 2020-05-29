import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/business.dart';

class HomeClientPresenter {
  HomeView _view;
  RemoteRepository _remoteRepository;
  Map<String, List> businessMap = Map();
  List<String> images = [];

  HomeClientPresenter(this._view, this._remoteRepository);

  init() async {
    try {
      images.clear();
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
      Map<String, List<Business>> mapAux = await _remoteRepository.getAllBusiness(businesses[i]);
      for(Business business in mapAux[businesses.elementAt(i)]){
        await getOneImageFromFirebase(business);
      }
      businessMap.addAll(mapAux);
    }

    await Images().getChilds(images, "assets/images/Store.png").then((value) {
      businessMap.putIfAbsent("Images", () => value);
      return true;
    }).then((value) => _view.showList(businessMap));

  }

  getOneImageFromFirebase(Business business) async {
    String url =
    await _remoteRepository.getOneImage(business.uid, "0", "Gallery");
    images.add(url);
  }
}

abstract class HomeView {
  showList(Map<String, List> hairDressing);
  showBusiness(List<String> business);
  changeLoading();
}