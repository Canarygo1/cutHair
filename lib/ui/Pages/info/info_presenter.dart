import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InfoPagePresenter {
  InfoView _view;
  RemoteRepository _remoteRepository;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userUid;

  InfoPagePresenter(this._view, this._remoteRepository);

  updateData(Map data, String uid, String password) async {
    try {
      FirebaseUser user = (await auth.signInWithEmailAndPassword(
              email: DBProvider.users[0].email, password: password))
          .user;
      await user.updateEmail(data['Email']);
      _view.showUpdate(await _remoteRepository.updateDataUser(data, uid));
      User userSQL = DBProvider.users[0];
      userSQL.email = data['Email'];
      userSQL.name = data['Nombre'];
      userSQL.surname = data['Apellidos'];
      DBProvider.update(userSQL);
    } on Exception catch (e) {
      _view.showUpdate(false);
    }
  }
}

abstract class InfoView {
  showUpdate(bool correct);
}
