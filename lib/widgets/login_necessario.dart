import 'package:flutter/material.dart';

class LoginNecessario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.vpn_key,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16),
            Text(
              "Login necessário",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            RaisedButton(
              child: Text("Entrar", style: TextStyle(fontSize: 18)),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: (){
                // Navigator.of(context).pushReplacement(
                    // MaterialPageRoute(builder: (context)=>LoginScreen())
                // );
              },
            )
          ],
        )
    );
  }
}
