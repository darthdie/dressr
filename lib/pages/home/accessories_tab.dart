import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:dressr/app_state.dart';
import 'package:dressr/models/accessory.dart';
import 'package:dressr/pages/add_accessory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AccessoryGridTile extends StatelessWidget {
  AccessoryGridTile({this.accessory, this.onTap});

  final Accessory accessory;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return new GridTile(
      child: new Material(
        child: new InkWell(
          child: new CircleAvatar(
            backgroundImage: new FileImage(new File(accessory.image)),
          ),
          onTap: () => onTap(accessory)
        )
      )
    );
  }
}

class AccessoriesTab extends StatelessWidget {
  const AccessoriesTab() : super();

  void handleGridTileTapped(Accessory accessory) {

  }

  List<Widget> _buildGridTiles(BuildContext context, _AccessoriesTabViewModel viewModel) {
    return viewModel.accessories
    .map((accessory) => new AccessoryGridTile(accessory: accessory, onTap: handleGridTileTapped))
    .toList();
  }

  Widget _buildBody(BuildContext context, _AccessoriesTabViewModel viewModel) {
    if (viewModel.accessories.isEmpty)  {
      return new Center(
        child: const Text("Looks like it's time to add some accessories!"),
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
    return new StoreConnector<AppState, _AccessoriesTabViewModel>(
      distinct: true,
      converter: (store) => new _AccessoriesTabViewModel.create(store),
      builder: (context, viewModel) {
        return new Scaffold(
          body: _buildBody(context, viewModel),
          floatingActionButton: new FloatingActionButton(
            heroTag: 'accessories-tab-fab',
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) => new AddAccessoryModal(), fullscreenDialog: true));
            },
          ),
        );
      },
    );
  }
}

class _AccessoriesTabViewModel {
  _AccessoriesTabViewModel({
    this.accessories
  });

  final BuiltList<Accessory> accessories;

  factory _AccessoriesTabViewModel.create(Store<AppState> store) {
    return new _AccessoriesTabViewModel(
      accessories: store.state.accessories
    );
  }

  @override
  operator ==(o) =>
    identical(o, this) ||
    o is _AccessoriesTabViewModel &&
    accessories == o.accessories;

  @override
  int get hashCode => accessories.hashCode;
}