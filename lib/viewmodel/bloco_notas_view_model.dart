import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/bloco_notas_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/firestore_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class BlocoNotasViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<BlocoNotasModel> _bloconotas;
  List<BlocoNotasModel> get bloconotas => _bloconotas;

  Future fetchBlocoNota() async {
    setBusy(true);

    List<BlocoNotasModel> items;
    StreamSubscription<QuerySnapshot> todoTasks;

    items = new List();

    todoTasks?.cancel();
    todoTasks = _firestoreService.getBlocoNotasRealTime().listen((QuerySnapshot snapshot) {
      final List<BlocoNotasModel> tasks = snapshot.docs
          .map((documentSnapshot) => BlocoNotasModel.fromMap(documentSnapshot.data(), "DocID")).toList();

      items = tasks;
    });
    setBusy(false);
  }

  Future fetchBlocoNotas() async {
    setBusy(true);
    var bloconotasResult = await _firestoreService.getBlocoNotasOnceOff(currentUser.wedding);
    setBusy(false);

    if (bloconotasResult == null){
      bloconotasResult = new List<BlocoNotasModel>();
    }

    if (bloconotasResult is List<BlocoNotasModel>){
      _bloconotas = bloconotasResult;
      notifyListeners();
    }else{
      await _dialogService.showDialog(
          title: 'Bloco notas update failed', // ToDo: String fixa
          description: bloconotasResult != null ? bloconotasResult : "Nenhum bloco de notas encontrado"
      );
    }
  }

  void editBlocoNotas(int index){
    _navigationService.navigateInTo(CreateBlocoNotasViewRoute, arguments: _bloconotas[index]);
  }

  Future deleteBlocoNotas(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza,
        description: MEString.querExcluir,
        confirmationTitle: MEString.sim,
        cancelTitle: MEString.nao
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      await _firestoreService.deleteBlocoNotas(currentUser.wedding, _bloconotas[index].did);
      setBusy(false);
    }
  }

}