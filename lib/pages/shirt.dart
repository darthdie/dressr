import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:dressr/app_state.dart';
import 'package:dressr/models/accessory.dart';
import 'package:dressr/models/shirt.dart';
import 'package:dressr/widgets/piece_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ShirtPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ShirtPageViewModel>(
      distinct: true,
      converter: (store) => new _ShirtPageViewModel.create(store),
      builder: (context, viewModel) {
        final accessories = viewModel.accessories.map((a) => new PieceTile(piece: a));

        return new Scaffold(
          body: new NestedScrollView(
            headerSliverBuilder: (context, isScrolled) {
              return <Widget>[
                new SliverAppBar(
                  expandedHeight: 256.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: new FlexibleSpaceBar(
                    background: new Image.file(new File(viewModel.shirt.image), fit: BoxFit.cover),
                  ),
                  actions: <Widget>[
                    new IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {

                      },
                    )
                  ],
                ),
              ];
            },
            body: new ListView(
              children: <Widget>[
                new ListTile(
                  title: new Text(viewModel.shirt.name, style: Theme.of(context).textTheme.title),
                  subtitle: new Text(viewModel.shirt.buttonable ? 'Buttonable' : 'Not Buttonable'),
                ),
                new ListTile(title: const Text('Goes With...')),
              ]
              ..addAll(accessories)
            ),
          )
        );
      },
    );
  }
}

class _ShirtPageViewModel {
  _ShirtPageViewModel({
    this.shirt,
    this.accessories
  });

  final Shirt shirt;
  final BuiltList<Accessory> accessories;

  factory _ShirtPageViewModel.create(Store<AppState> store) {
    return new _ShirtPageViewModel(
      shirt: store.state.selectedShirt,
      accessories: new BuiltList<Accessory>()
    );
  }

  @override
  operator ==(o) =>
    identical(this, o) ||
    o is _ShirtPageViewModel &&
    shirt == o.shirt &&
    accessories == o.accessories;

  @override
  int get hashCode =>
    this.shirt.hashCode ^
    this.accessories.hashCode;
}