import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/business.dart';
import 'package:flutter/cupertino.dart';

class HomeClientPresenter {
  HomeView _view;
  RemoteRepository _remoteRepository;
  List<String> images = [];

  HomeClientPresenter(this._view, this._remoteRepository);

  init(Map<String, List> selectedFilters) async {
    images.clear();
    List<String> businessType = await _remoteRepository.getBusiness();
    await _view.showBusiness(businessType);
    await chargeBusiness(selectedFilters);
    _view.changeLoading();
  }

  chargeBusiness(Map<String, List> selectedFilters) async {
    List<QuerySnapshot> querySnapshot =
        await _remoteRepository.getAllQuery(selectedFilters);
    Map<String, List<Business>> mapAux =
        await _remoteRepository.getAllBusiness(selectedFilters, querySnapshot);
    List<List<Business>> auxList = mapAux.values.toList();
      for (var item in auxList) {
          for (var business in item) {
            await getOneImageFromFirebase(business);
          }
      }
    List<Widget> logoBusinesses = [];
    await Images().getChilds(images, "assets/images/Store.png").then((value) {
      logoBusinesses = value;
      return true;
    }).then((value) => _view.showList(mapAux, logoBusinesses));
  }

  getOneImageFromFirebase(Business business) async {
    String url =
        await _remoteRepository.getOneImage(business.uid, "0", "Gallery");
    images.add(url);
  }
}

abstract class HomeView {
  showList(Map<String, List> business, List<Widget> images);

  showBusiness(List<String> business);

  changeLoading();
}
