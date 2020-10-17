import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/business_type.dart';
import 'package:cuthair/model/image_business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeClientPresenter {
  HomeView _view;
  RemoteRepository _remoteRepository;
  final storage = new FlutterSecureStorage();

  HomeClientPresenter(this._view, this._remoteRepository);

  init() async {
    try {
      List<BusinessType> businessTypes =
          await _remoteRepository.getBusinessTypes();
      await _view.showBusiness(businessTypes);
      await chargeBusiness(businessTypes);
      _view.changeLoading();
    } catch (e) {
      if (e == 'JWT error') {
        String refreshToken = await storage.read(key: 'RefreshToken');
        await GlobalMethods().generateNewAccessToken(refreshToken);
        await init();
      }
    }
  }

  chargeBusiness(List<BusinessType> businessType) async {
    String accessToken = await storage.read(key: 'AccessToken');
    List<Business> business = await _remoteRepository.getAllBusiness();
    for (Business value in business) {
      value.images = await _remoteRepository.getAllImages(value, accessToken);
      if(value.images.isEmpty || value.images == null){
        value.widget = Image.asset(
          'assets/images/Store.png',
          fit: BoxFit.cover,
        );
      }else{
        ImageBusiness imageBusiness = value.images.firstWhere((element) => element.type == "logo");
        value.widget = Image.network(
          imageBusiness.url,
          fit: BoxFit.cover,
        );
      }
    }

    Map<String, List<Business>> map = new Map();

    businessType.forEach((types) {
      List<Business> aux = [];
      business.forEach((value) async {
        if (value.typeId == types.id) {
          aux.add(value);
        }
      });
      map.putIfAbsent(types.type, () => aux);
    });
    _view.showList(map);
  }
}

abstract class HomeView {
  showList(Map<String, List<Business>> business);

  showBusiness(List<BusinessType> business);

  changeLoading();
}
