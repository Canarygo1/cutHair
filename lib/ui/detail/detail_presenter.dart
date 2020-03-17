
import 'package:cuthair/data/remote/remote_repository.dart';

class DetailPresenter {
  DetailView _view;
  RemoteRepository _remoteRepository;

  DetailPresenter(this._view, this._remoteRepository);

  init() async {
    print("dentro");
//    Firestore firestore = Firestore.instance;
//    QuerySnapshot querySnapshot = await firestore
//        .collection("Peluquerias")
//        .document("PR01")
//        .collection("servicios")
//        .getDocuments();
//    print(querySnapshot.documents[0].data);
    _view.showServices(await _remoteRepository.getAllServices());
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
}
