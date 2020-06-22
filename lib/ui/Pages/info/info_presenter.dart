import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InfoPagePresenter {
  InfoView _view;
  RemoteRepository _remoteRepository;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userUid;

  InfoPagePresenter(this._view, this._remoteRepository);

  updateData (Map data, String uid) async {
    _view.showUpdate(await _remoteRepository.updateDataUser(data, uid));
  }
}

abstract class InfoView {
  showUpdate(bool correct);
}
