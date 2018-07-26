import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:dressr/app_state.dart';
import 'package:dressr/models/shirt.dart';
import 'package:dressr/pages/add_shirt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ShirtGridTile extends StatelessWidget {
  ShirtGridTile({this.shirt, this.onTap});

  final Shirt shirt;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return new GridTile(
      child: new Material(
        child: new InkWell(
          child: new CircleAvatar(
            backgroundImage: new FileImage(new File(shirt.image)),
          ),
          onTap: () => onTap(shirt)
        )
      )
    );
  }
}

class ShirtsTab extends StatelessWidget {
  const ShirtsTab() : super();

  void handleGridTileTapped(Shirt shirt) {

  }

  List<Widget> _buildGridTiles(BuildContext context, _ShirtsTabViewModel viewModel) {
    return viewModel.shirts
    .map((shirt) => new ShirtGridTile(shirt: shirt, onTap: handleGridTileTapped))
    .toList();
  }

  Widget _buildBody(BuildContext context, _ShirtsTabViewModel viewModel) {
    if (viewModel.shirts.isEmpty)  {
      return new Center(
        child: const Text("Looks like it's time to add some shirts!"),
      );
    }

    return new GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(8.0),
      crossAxisSpacing: 8.0,
      children: _buildGridTiles(context, viewModel)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ShirtsTabViewModel>(
      distinct: true,
      converter: (store) => new _ShirtsTabViewModel.create(store),
      builder: (context, viewModel) {
        return new Scaffold(
          body: _buildBody(context, viewModel),
          floatingActionButton: new FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) => new AddShirtModal()));
            },
          ),
        );
      },
    );
  }
}

class _ShirtsTabViewModel {
  _ShirtsTabViewModel({
    this.shirts
  });

  final BuiltList<Shirt> shirts;

  factory _ShirtsTabViewModel.create(Store<AppState> store) {
    return new _ShirtsTabViewModel(
      shirts: store.state.shirts
    );
  }

  @override
  operator ==(o) =>
    identical(o, this) ||
    o is _ShirtsTabViewModel &&
    shirts == o.shirts;

  @override
  int get hashCode =>
    shirts.hashCode;
}