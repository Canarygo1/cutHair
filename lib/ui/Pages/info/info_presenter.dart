import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InfoPagePresenter {
  InfoView _view;
  RemoteRepository _remoteRepository;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userUid;

  InfoPagePresenter(this._view, this._remoteRepository);

  init() async {
    try {
      await currentUser();
      _view.showList(await _remoteRepository.getUser(userUid));
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> currentUser() async {
    final FirebaseUser user = await auth.currentUser();
    userUid = user.uid;
  }
}

abstract class InfoView {
  showList(User user);
}
