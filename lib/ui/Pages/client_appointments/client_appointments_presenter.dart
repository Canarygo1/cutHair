import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/my_appointment.dart';

class ClientAppointmentsPresenter {
  MyAppointmentsView _view;
  RemoteRepository _remoteRepository;
  List<String> allImages = [];

  ClientAppointmentsPresenter(this._view, this._remoteRepository);

  init(String userUid, DateTime date, bool firstTime) async {
    allImages = [];
    try {
      List<MyAppointment> myAppointment = [];
       myAppointment = await _remoteRepository
           .getUserAppointments(userUid, date, firstTime);
       await getAllImages(myAppointment);
      _view.showImages(allImages);
      _view.showAppointments(myAppointment);
    }catch(e){
      _view.emptyAppointment();
    }
  }

  getAllImages(List<MyAppointment> myAppointment) async{
    for(int i = 0; i < myAppointment.length; i++){
      String image = await _remoteRepository.getOneImage(myAppointment.elementAt(i).businessUid, "0", "Gallery");
      image.length == 0 ? allImages.add("assets/images/Name.png") : allImages.add(image);
    }
  }

  removeAppointment(MyAppointment appointment, int index, String userUid, DateTime date) async {
    try{
      await _remoteRepository.removeAppointment(appointment);
      await init(userUid, date, true);
    }catch(Exception){
      _view.emptyAppointment();
    }

  }
}

abstract class MyAppointmentsView {
  showAppointments(List<MyAppointment> myAppointment);
  showImages(List<String> images);
  emptyAppointment();
}
