import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InfoPagePresenter {
  InfoView _view;
  RemoteRepository _remoteRepository;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;

  InfoPagePresenter(this._view, this._remoteRepository);

  init() async {
    await currentUser();
    _view.showList(await _remoteRepository.getUser(uid));
  }

  Future<void> currentUser() async {
    final FirebaseUser user = await auth.currentUser();
    uid = user.uid;
  }
}

abstract class InfoView {
  showList(User user);
}
