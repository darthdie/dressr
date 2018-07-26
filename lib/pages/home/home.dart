import 'package:dressr/pages/home/accessories_tab.dart';
import 'package:dressr/pages/home/shirts_tab.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          bottom: const TabBar(
            tabs: <Widget>[
              const Tab(icon: const Icon(FontAwesomeIcons.tshirt)),
              const Tab(icon: const Icon(FontAwesomeIcons.blackTie)),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            const ShirtsTab(),
            const AccessoriesTab(),
          ],
        ),
      )
    );
  }
}
