import 'package:flutter/material.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/local_cerimonia_model.dart';

import 'package:meenforquei/viewmodel/base_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/firestore_service.dart';
import 'package:meenforquei/services/navigation_service.dart';

class CreateLocalCerimoniaViewModel extends BaseModel {

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  LocalCerimoniaModel _edittingLocal;
  bool get _editting => _edittingLocal != null;

  Future addLocal({@required String title}) async{
    setBusy(true);

    var result;

    if (!_editting){
      result = await _firestoreService
          .addLocal(currentUser.wedding, LocalCerimoniaModel(title: title, uid: currentUser.uid));
    }else{
      result = await _firestoreService.updateLocal(currentUser.wedding, LocalCerimoniaModel(
          title: title
      ));
    }

    setBusy(false);

    if (result is String){
      await _dialogService.showDialog(
          title: 'Could not create local', // ToDo: String fixa
          description: result
      );
    }else{
      await _dialogService.showDialog(
          title: 'Local successfully added', // ToDo: String fixa
          description: 'Your local has been created' // ToDo: String fixa
      );
    }

    _navigationService.pop();
  }

  void setEdittingLocal(LocalCerimoniaModel edittingLocal){
    _edittingLocal = edittingLocal;
  }

}
