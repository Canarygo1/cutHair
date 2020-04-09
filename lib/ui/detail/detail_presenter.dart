
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/hairDressing.dart';

class DetailPresenter {
  DetailView _view;
  RemoteRepository _remoteRepository;

  DetailPresenter(this._view, this._remoteRepository);

  init(HairDressing hairDressing) async {
    _view.showServices(await _remoteRepository.getAllServices());
    _view.showImages(await _remoteRepository.getAllImages(hairDressing));

  }
}

//    DocumentReference querySnapshot = await firestore
//        .collection("Peluquerias")
//        .document("PR01")
//        .collection("empleados")
//        .document("Carlos");
//
//    querySnapshot.get().then((datasnapshot) {
//      if (datasnapshot.exists) {
//        print(datasnapshot.data);
//      }
//    });
abstract class DetailView {
  showServices(List servicios);
  showImages(List imagenes);
}
