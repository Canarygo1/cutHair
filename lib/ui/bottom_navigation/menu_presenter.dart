import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/model/user.dart';

class MenuPresenter{
  RemoteRepository _remoteRepository;
  User _user;
  MenuView _view;

  MenuPresenter(this._remoteRepository, this._user, this._view);

   init() async{

     if (_user.permission == 1)
    {
      _view.goToBoss(await _remoteRepository.getHairdressingByUid(_user.hairdressingUid));
    }
    else if (_user.permission == 2){
       HairDressing hairDressing = await _remoteRepository.getHairdressingByUid(_user.hairdressingUid);
       _view.goToEmployee(hairDressing);
    }
    else {
      _view.goToClient();
    }
  }
}

abstract class MenuView{
  goToEmployee(HairDressing hairDressing);
  goToBoss(HairDressing hairDressing);
  goToClient();
}