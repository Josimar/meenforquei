import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meenforquei/viewmodel/app_viewmodel.dart';
import 'package:meenforquei/interfaces/shared_storage_interface.dart';
import 'package:meenforquei/services/storage_service_shared_preferences.dart';
import 'package:meenforquei/viewmodel/change_theme_viewmodel.dart';

// https://medium.com/flutter-community/creating-services-to-do-the-work-in-your-flutter-app-93d6c4aa7697

class AppController{

  // Singleton
  static final AppController instance = AppController._();
  AppController._(){
    changeThemeViewModel.init();
    appViewModel.init();
  }

  final ChangeThemeViewModel changeThemeViewModel = ChangeThemeViewModel(
    storage: StorageServiceSharedPreferences()
  );

  final AppViewModel appViewModel = AppViewModel(
    storage: StorageServiceSharedPreferences()
  );

  bool get isDark => changeThemeViewModel.config.themeSwitch.value;
  ValueNotifier<bool> get themeSwitch => changeThemeViewModel.config.themeSwitch;

  bool get viewIntroScreen => appViewModel.config.viewIntroScreen.value;
  ValueNotifier<bool> get viewIntroSwitch => appViewModel.config.viewIntroScreen;

  final ISharedStorage storage = StorageServiceSharedPreferences();
}