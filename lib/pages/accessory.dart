import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:dressr/app_state.dart';
import 'package:dressr/models/accessory.dart';
import 'package:dressr/models/shirt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AccessoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _AccessoryPageViewModel>(
      distinct: true,
      converter: (store) => new _AccessoryPageViewModel.create(store),
      builder: (context, viewModel) {
        // final accessories = viewModel.accessories.map((a) {
        //   return new AccessoryTile(
        //     accessory: a
        //   );
        // });

        // return new Scaffold(
        //   body: new NestedScrollView(
        //     headerSliverBuilder: (context, isScrolled) {
        //       return <Widget>[
        //         new SliverAppBar(
        //           expandedHeight: 256.0,
        //           floating: false,
        //           pinned: true,
        //           flexibleSpace: new FlexibleSpaceBar(
        //             background: new Image.file(new File(viewModel.shirt.image), fit: BoxFit.cover),
        //           ),
        //         )
        //       ];
        //     },
        //     body: new ListView(
        //       children: <Widget>[
        //         new ListTile(
        //           title: new Text(viewModel.shirt.name, style: Theme.of(context).textTheme.title),
        //           subtitle: new Text(viewModel.shirt.buttonable ? 'Buttonable' : 'Not Buttonable'),
        //         ),
        //         new ListTile(title: const Text('Goes With...')),
        //       ]
        //       ..addAll(accessories)
        //     ),
        //   )
        // );
      },
    );
  }
}

class _AccessoryPageViewModel {
  _AccessoryPageViewModel({
    this.accessory,
    this.shirts
  });

  final Accessory accessory;
  final BuiltList<Shirt> shirts;

  factory _AccessoryPageViewModel.create(Store<AppState> store) {
    return new _AccessoryPageViewModel(
      // accessory: store.state.selectedAccessory,
      // shirts: new BuiltList<Shirt>(store.state.selectedAccessory.shirts.map((id) => store.state.accessories.firstWhere((a) => a.id == id)))
    );
  }

  @override
  operator ==(o) =>
    identical(this, o) ||
    o is _AccessoryPageViewModel &&
    accessory == o.accessory &&
    shirts == o.shirts;

  @override
  int get hashCode =>
    this.accessory.hashCode ^
    this.shirts.hashCode;
}