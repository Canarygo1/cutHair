import 'package:cuthair/data/remote/Api/api_remote_repository.dart';

class ChooseDatePresenter{
  ChooseDateView _view;
  ApiRemoteRepository _remoteRepository;

  ChooseDatePresenter(this._view, this._remoteRepository);

  init(String duration,String date,String employeeUid) async {
    try {
      List availability = await _remoteRepository.getAvailability(
          duration, employeeUid, date);

      _view.showAvailability(availability);
    }catch(e){
      _view.emptyAvailability();
    }
  }
}

abstract class ChooseDateView{
  showAvailability(List<String> availability);
  emptyAvailability();
}