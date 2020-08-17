import 'package:cuthair/model/user.dart';

class MenuPresenter{
  MenuView _view;

  MenuPresenter(this._view);

   init(User user) async{
     if(user == null){
      _view.goToClientWithOutLogin();
     }else{
       _view.goToClient();
     }
  }
}

abstract class MenuView{
  goToClient();
  goToClientWithOutLogin();
}