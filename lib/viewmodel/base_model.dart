import 'package:flutter/widgets.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/user_model.dart';
import 'package:meenforquei/services/authentication_service.dart';

class BaseModel extends ChangeNotifier {

  final AuthenticationService _authenticationService = locator<AuthenticationService>();

  UserModel get currentUser => _authenticationService.currentUser;
  bool get userLogged => _authenticationService.userLogged;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
