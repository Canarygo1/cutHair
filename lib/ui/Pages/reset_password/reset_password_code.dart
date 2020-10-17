import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:http/http.dart';

class ResetPasswordCode{
  RemoteRepository _remoteRepository;
  ResetPasswordCode(this._remoteRepository);

  changePassword(String email) async {
    try {
      String response = await _remoteRepository.resetPassword(email);
    }catch(e){
      print(e);
    }
  }

}
abstract class ResetPasswordView{
  showEmailSend(String texto);
}