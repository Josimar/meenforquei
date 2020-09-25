import 'package:flutter/material.dart';
import 'package:meenforquei/components/custom_switch_widget.dart';
import 'package:meenforquei/utils/meenforquei.dart';

class ConfigTab extends StatefulWidget {
  @override
  _ConfigTabState createState() => new _ConfigTabState();
}

class _ConfigTabState extends State<ConfigTab> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MEString.name),
        actions: <Widget>[
          Padding(
            child: Icon(Icons.search),
            padding: const EdgeInsets.only(right: 10.0),
          )
        ],
      ),
      drawer: Drawer(),
      body: new Center(
          child: new Column(
            children: <Widget>[
              CustomSwitchWidget(),
              CustomSwitchIntroWidget()
            ],
          )),
    );
  }
}

