import 'dart:io';

import 'package:flutter/material.dart';

class ImageGridTile extends StatelessWidget {
  ImageGridTile({this.path, this.onTap});

  final String path;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return new GridTile(
      child: new Material(
        child: new InkWell(
          child: new CircleAvatar(
            backgroundImage: new FileImage(new File(path)),
          ),
          onTap: () => onTap()
        )
      )
    );
  }
}