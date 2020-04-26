import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/user.dart';

class MenuPresenter{
  RemoteRepository _remoteRepository;
  User _user;
  MenuView _view;

  MenuPresenter(this._remoteRepository, this._user, this._view);
   init() async{
      _view.goToClient();
  }
}

abstract class MenuView{
  goToClient();
}