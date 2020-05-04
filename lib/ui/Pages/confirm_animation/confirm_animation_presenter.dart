import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmAnimationPresenter{
  ConfirmAnimationView _view;
  RemoteRepository _remoteRepository;

  ConfirmAnimationPresenter(this._view, this._remoteRepository);

  init(Appointment appointment) async {
    try {
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