import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmScreenPresenter{
  ConfirmScreenView _view;
  RemoteRepository _remoteRepository;
  DBProvider _dbProvider;
  FirebaseUser auth;
  ConfirmScreenPresenter(this._view, this._remoteRepository);
  init(Appointment appointment) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
        _remoteRepository.insertAppointment(appointment, user.uid);
  }
}

abstract class ConfirmScreenView{

}