import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {

  final String avatarUrl;
  final Function onTap;

  AvatarWidget({this.avatarUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
          child: avatarUrl == null ? CircleAvatar(
            radius:50,
            child: Icon(Icons.photo_camera),
          ) : CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(avatarUrl),
          )
      ),
    );
  }
}
