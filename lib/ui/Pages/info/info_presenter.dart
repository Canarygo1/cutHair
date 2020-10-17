import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InfoPagePresenter {
  InfoView _view;
  RemoteRepository _remoteRepository;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  InfoPagePresenter(this._view, this._remoteRepository);

  updateData(User user, String id) async {
    try {
      String accessToken = await storage.read(key: 'AccessToken');
      bool isCorrect =
          await _remoteRepository.updateDataUser(user, accessToken);
      if (isCorrect == true) {
        DBProvider.update(user);
        _view.showUpdate(true);
      } else {
        _view.showUpdate(false);
      }
    } catch (e) {
      if (e == 'JWT error') {
        String refreshToken = await storage.read(key: 'RefreshToken');
        await GlobalMethods().generateNewAccessToken(refreshToken);
        await updateData(user, id);
      } else {
        _view.showUpdate(false);
      }
    }
  }
}

abstract class InfoView {
  showUpdate(bool correct);
}
