import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChargeScreenPresenter {
  ChargeScreenView view;
  RemoteRepository _remoteRepository;
  final storage = new FlutterSecureStorage();

  ChargeScreenPresenter(this.view, this._remoteRepository);

  init(String software) async {
    String version = await _remoteRepository.getVersionApp(software);
    view.showVersion(version);
  }
}

abstract class ChargeScreenView {
  showVersion(String version);
}
