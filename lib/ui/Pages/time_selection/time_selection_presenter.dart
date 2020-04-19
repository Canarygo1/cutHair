import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/user.dart';

class TimeSelectionPresenter{
  TimeSelectionView _view;
  RemoteRepository _remoteRepository;

  TimeSelectionPresenter(this._view, this._remoteRepository);

  phoneNumberCheck(String phoneNumber ) async {
    try {
      User user = await _remoteRepository.getUserByPhoneNumber(phoneNumber);
      _view.userExist(user);
    }catch(e) {
      _view.userNotExist();
    }
  }
  checkUser(User user, int positionSelected,String name ,String phoneNumber) async {
    try{
      if(user.uid != null){
        _view.goToNextScreen(user);
      }
    }catch(e){
        User anonimousUser = User("", name, "", 3, phoneNumber, "");
        anonimousUser = await _remoteRepository.insertAnonymousUser(anonimousUser);
        print(anonimousUser.uid.length);
        _view.userCreated(anonimousUser);
    }
  }
}

abstract class TimeSelectionView{
   userExist(User user);
   userCreated(User user);
   userNotExist();
   goToNextScreen(User user);
}