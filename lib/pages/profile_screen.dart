import 'package:flutter/material.dart';
import 'package:meenforquei/models/user_model.dart';
import 'package:meenforquei/widgets/avatar_widget.dart';

class ProfileScreen extends StatefulWidget {
  static String route = 'profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel currentUser;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:Theme.of(context).primaryColor,
                borderRadius:BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  AvatarWidget(
                    avatarUrl: currentUser?.avatarUrl,
                    onTap: (){
                      // ToDo: open gallery select an image
                      // Upload the imagem to firebase storage
                      // Set state to current user
                    },
                  ),
                  Text("Hi, ${currentUser?.name ?? "nice to see you here"}") // ToDo: String fixo
                ]
              )
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(hintText: "Username")
                  ),
                  SizedBox(height:20),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                            "Manage password"
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
