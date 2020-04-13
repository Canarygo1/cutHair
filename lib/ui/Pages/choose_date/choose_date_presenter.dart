import 'package:cuthair/data/remote/Api/api_remote_repository.dart';

class ChooseDatePresenter{
  ChooseDateView _view;
  ApiRemoteRepository _remoteRepository;

  ChooseDatePresenter(this._view, this._remoteRepository);

  init(String duration,String date,String hairdresser) async {
    List availability = await _remoteRepository.getAvailability(duration, hairdresser, date);
    _view.showAvailability(availability);
  }
}

abstract class ChooseDateView{
  showAvailability(List<String> availability);
}