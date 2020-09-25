import 'package:flutter/material.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/noticia_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/firestore_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class CreateNoticiaViewModel extends BaseModel {

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  NoticiaModel _edittingNoticia;
  bool get _editting => _edittingNoticia != null;

  Future addNoticia({@required String title}) async{
    setBusy(true);

    var result;

    if (!_editting){
      result = await _firestoreService
          .addNoticia(currentUser.wedding, NoticiaModel(title: title, uid: currentUser.uid));
    }else{
      result = await _firestoreService.updateNoticia(currentUser.wedding, NoticiaModel(
          title: title
      ));
    }

    setBusy(false);

    if (result is String){
      await _dialogService.showDialog(
          title: 'Could not create news', // ToDo: String fixa
          description: result
      );
    }else{
      await _dialogService.showDialog(
          title: 'News successfully added', // ToDo: String fixa
          description: 'Your new has been created' // ToDo: String fixa
      );
    }

    _navigationService.pop();
  }

  void setEdittingNoticia(NoticiaModel edittingNoticia) {
    _edittingNoticia = edittingNoticia;
  }

}