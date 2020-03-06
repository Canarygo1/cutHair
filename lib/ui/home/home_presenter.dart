import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/remote_repository.dart';

import '../../model/hairDressing.dart';

class HomePagePresenter {
  HomeView _view;
  RemoteRepository _remoteRepository;


  HomePagePresenter(this._view, this._remoteRepository);

  init() async {
    print("dentro");
    _view.showList(await _remoteRepository.getAllHairdressing());

    //Conseguir documents.
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
  }
}

abstract class HomeView {
  showList(List<HairDressing> hairDressing);
}
