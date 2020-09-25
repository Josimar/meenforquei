import 'package:flutter/material.dart';
import 'package:meenforquei/models/agenda_model.dart';
import 'package:meenforquei/utils/meenforquei.dart';

class AgendaDetailView extends StatelessWidget {
  final AgendaModel edittingAgenda;

  AgendaDetailView({Key key, this.edittingAgenda}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MEString.agendaDetail),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(edittingAgenda.title, style: Theme.of(context).textTheme.display1,),
            SizedBox(height: 20.0),
            Text(edittingAgenda.description)
          ],
        ),
      ),
    );
  }
}
