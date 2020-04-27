

class MenuPresenter{
  MenuView _view;

  MenuPresenter(this._view);
   init() async{
      _view.goToClient();
  }
}

abstract class MenuView{
  goToClient();
}