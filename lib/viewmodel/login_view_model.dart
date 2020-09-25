import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/services/authentication_service.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future quemSouEu(String uid) async {
    await _authenticationService.populateCurrentUserId(uid);
  }

  Future login({
    @required String email,
    @required String password,
  }) async {
    setBusy(true);

    var result = await _authenticationService.loginWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: MEString.errorLogin,
          description: MEString.errorLoginDescription,
        );
      }
    } else {
      await _dialogService.showDialog(
        title: MEString.errorLogin,
        description: result,
      );
    }
  }

  void recoverPass(String email){
    // ToDo: Recupeara a senha
  }

  Future signOut() async {
    setBusy(true);
    await _authenticationService.signOut();
    setBusy(false);
  }

  void goToRemoveDrawer(BuildContext context){
    Navigator.of(context).pop(context);
  }

  void navigateToLogin() {
    _navigationService.navigateTo(LoginViewRoute);
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(SignUpViewRoute);
  }
}
