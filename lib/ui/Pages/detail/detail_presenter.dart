import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/image_business.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DetailPresenter {
  DetailView _view;
  RemoteRepository _remoteRepository;
  final storage = new FlutterSecureStorage();

  DetailPresenter(this._view, this._remoteRepository);

  init(Business business) async {
    try {
      String accessToken = await storage.read(key: 'AccessToken');
      _view.showImages(business.images);
      List services =
          await _remoteRepository.getAllServices(business.id, accessToken);
      _view.showServices(services);
    } catch (e) {
      if (e == 'JWT error') {
        String refreshToken = await storage.read(key: 'RefreshToken');
        await GlobalMethods().generateNewAccessToken(refreshToken);
        await init(business);
      }
    }
  }
}

abstract class DetailView {
  showServices(List services);

  showImages(List<ImageBusiness> images);
}
