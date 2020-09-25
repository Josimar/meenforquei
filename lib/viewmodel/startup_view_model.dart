import 'dart:async';

import 'package:meenforquei/locator.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/services/authentication_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    // _authenticationService.signOut(); // ToDo: logoff na raiz

    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
    var viewIntroUser = false;
    if (hasLoggedInUser){
      viewIntroUser = await _authenticationService.isUserViewIntro(currentUser.uid);
    }

    new Timer(const Duration(milliseconds: 3000), (){
      if (hasLoggedInUser) {
        if (viewIntroUser){
          _navigationService.navigateTo(IntroViewRoute);
        }else{
          _navigationService.navigateTo(HomeViewRoute);
        }
      } else {
        _navigationService.navigateTo(LoginViewRoute);
      }
    });
  }

  void goToHome(){
    _navigationService.navigateTo(HomeViewRoute);
  }
}
