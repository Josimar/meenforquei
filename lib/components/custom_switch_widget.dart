import 'package:flutter/material.dart';
import 'package:meenforquei/controllers/app_controller.dart';

class CustomSwitchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: AppController.instance.isDark,
      onChanged: (value){
        AppController.instance.changeThemeViewModel.changeTheme(value);
      },
    );
  }
}

class CustomSwitchIntroWidget extends StatefulWidget {
  @override
  _CustomSwitchIntroWidgetState createState() => _CustomSwitchIntroWidgetState();
}

class _CustomSwitchIntroWidgetState extends State<CustomSwitchIntroWidget> {
  bool _viewIntro = false; // AppController.instance.viewIntroScreen;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _viewIntro,
      onChanged: (value){
        AppController.instance.appViewModel.changeViewIntro(value);
        setState(() {
          _viewIntro = value;
        });
        if (value){

        }
      },
    );
  }
}