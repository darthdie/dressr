import 'dart:io';

import 'package:dressr/models/piece.dart';
import 'package:flutter/material.dart';

class PieceTile extends StatelessWidget {
  PieceTile({Key key, this.piece, this.onPressed, this.trailing}) : super(key: key);

  final Piece piece;
  final Function onPressed;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: new ListTile(
        leading: new CircleAvatar(
          backgroundImage: new FileImage(new File(piece.image)),
          radius: 28.0
        ),
        title: new Text(piece.name),
        trailing: trailing,
        onTap: onPressed,
      )
    );
  }
}