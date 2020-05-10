 import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmAnimationPresenter{

  ConfirmAnimationView _view;
  RemoteRepository _remoteRepository;
  ApiRemoteRepository _apiRemoteRepository;

  ConfirmAnimationPresenter(this._view, this._remoteRepository,this._apiRemoteRepository);

  init(Appointment appointment) async {
    try {
      DateTime initial = appointment.checkIn.subtract(Duration(
          hours: appointment.checkIn.hour,
          minutes: appointment.checkIn.minute,
          seconds: appointment.checkIn.second,
          microseconds: appointment.checkIn.microsecond,
          milliseconds: appointment.checkIn.millisecond));
      List<String> appointments = await _apiRemoteRepository.getAvailability(
          appointment.service.duration.toString(),
          appointment.employee.name,
          initial.toString()
      );

      bool isInAppointments = appointments
          .contains(appointment.checkIn.hour.toString()+":"+appointment.checkIn.minute.toString());


      if(!isInAppointments){
        print("hola");
        throw Exception;
      }

      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseUser user = await auth.currentUser();
      _remoteRepository.insertAppointment(appointment, user.uid);
      _view.correctInsert();
    }catch(e){
      _view.incorrectInsert();
    }
  }
}
abstract class ConfirmAnimationView{
  correctInsert();
  incorrectInsert();
}