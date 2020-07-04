import 'package:cuthair/data/remote/remote_repository.dart';

class ChargeScreenPresenter {
  ChargeScreenView view;
  RemoteRepository _remoteRepository;

  ChargeScreenPresenter(this.view, this._remoteRepository);

  init(String software) async {
    view.showVersion(await _remoteRepository.getAplicationVersion(software));
  }

}

abstract class ChargeScreenView{
  showVersion(String version);
}
