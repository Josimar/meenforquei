import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meenforquei/viewmodel/startup_view_model.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("image/splashscreen.jpg"), fit: BoxFit.cover
                  )
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 50.0,
                          child: IconButton(
                            onPressed:(){},
                            icon: FaIcon(FontAwesomeIcons.church),
                            color: Colors.white,
                            iconSize: 65.0,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        Text(
                          MEString.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 200),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      Text(
                        MEString.descricao,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
