import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  var _label;
  var _buttonWidth;

  DefaultButton(this._label, this._buttonWidth);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30)
      ),
      alignment: Alignment.center,
      width: _buttonWidth == 0 ? MediaQuery.of(context).size.width - 48 : _buttonWidth,
      child: Text(_label, style: TextStyle(color: Colors.white),),
    );
  }

}
