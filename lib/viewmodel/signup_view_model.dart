import 'package:meenforquei/locator.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/services/authentication_service.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:flutter/foundation.dart';

import 'base_model.dart';

class SignUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  String _selectedRole = 'Select a User Role';
  String get selectedRole => _selectedRole;

  void setSelectedRole(dynamic role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future signUp({
    @required Map<String, dynamic> userData,
    @required Map<String, dynamic> userCData,
    @required String dataCasal,
    @required String tagCasal,
    @required String pass,
    @required String passC,
    @required bool ehCasal,
  }) async {
    setBusy(true);

    String userID = "";

    if (ehCasal){
      String nomePar1 = userCData["name"];        // pegar o primeiro nome do casal
      nomePar1 = nomePar1.split(" ").elementAt(0);
      String nomePar2 = userData["name"];         // pegar o primeiro nome do casal
      nomePar2 = nomePar2.split(" ").elementAt(0);

      // Salva o casamento
      String wedId = await _authenticationService.createWedding(tagCasal: tagCasal, nomePar1: nomePar1, nomePar2: nomePar2);

      // register and return conjuge
      String userParID = await _authenticationService.signUpWithEmailUserPar(userCData["email"], passC);

      // Salva o conjuge
      // register user = conjuge
      userCData["tagcasal"] = tagCasal;
      userCData["data"] = dataCasal;
      userCData["wedding"] = wedId;
      await _authenticationService.createUser(userCData, userParID.trim());

      await _authenticationService.saveCasal(wedId.trim(), userParID.trim(), userCData);

      // register and return user
      userID = await _authenticationService.signUpWithEmailUser(userData["email"], pass);

      // Salva o user
      // Dados do user
      userData["tagcasal"] = tagCasal;
      userData["data"] = dataCasal;
      userData["wedding"] = wedId;
      await _authenticationService.createUser(userData, userID.trim());

      await _authenticationService.saveCasal(wedId.trim(), userID.trim(), userData);
    }else{
      String temAhTag = await _authenticationService.verifyWedding(tagCasal);

      if (temAhTag.isNotEmpty) {
        // register and return user
        userID = await _authenticationService.signUpWithEmailUser(userData["email"], pass);

        await _authenticationService.createUser(userData, userID);
        await _authenticationService.saveUserDataWedding(temAhTag, userID);

        userData["user"] = userID;
        await _authenticationService.saveUserConvidadoWedding(temAhTag, userID, userData);
      }
    }

    setBusy(false);

    var result = userID != "";

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failure',
        description: userID // result,
      );
    }
  }

  void goToLogin(){
    _navigationService.navigateTo(LoginViewRoute);
  }
}
