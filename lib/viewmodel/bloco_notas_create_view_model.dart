import 'package:flutter/material.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/bloco_notas_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/firestore_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class CreateBlocosNotasViewModel extends BaseModel {

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  BlocoNotasModel _edittingBlocoNotas;
  bool get _editting => _edittingBlocoNotas != null;

  Future addBlocoNotas({@required String title, String description, String type}) async{
    setBusy(true);

    var result;

    if (!_editting){
      result = await _firestoreService
          .addBlocoNotas(currentUser.wedding, BlocoNotasModel(title: title, description: description, type: type, date: DateTime.now().toString(), uid: currentUser.uid));
    }else{
      /*
      result = await _firestoreService.updateBlocoNotas(currentUser.wedding, BlocoNotasModel(
          title: title,
          userId: _edittingBlocoNotas.userId,
          documentId: _edittingBlocoNotas.documentId
      ));
      */
    }

    setBusy(false);

    if (result is String){
      await _dialogService.showDialog(
          title: 'Could not create bloco notas', // ToDo: String fixa
          description: result
      );
    }else{
      await _dialogService.showDialog(
          title: 'Bloco notas successfully added', // ToDo: String fixa
          description: 'Your bloco notas has been created' // ToDo: String fixa
      );
    }

    _navigationService.pop();
  }

  void setEdittingBlocoNotas(BlocoNotasModel _edittingBlocoNotas){
    _edittingBlocoNotas = _edittingBlocoNotas;
  }

}
