import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:dressr/app_state.dart';
import 'package:dressr/models/accessory.dart';
import 'package:dressr/models/outfit.dart';
import 'package:dressr/models/piece.dart';
import 'package:dressr/models/shirt.dart';
import 'package:dressr/widgets/piece_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ViewOutfitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _OutfitPageViewModel>(
      distinct: true,
      converter: (store) => new _OutfitPageViewModel.create(store),
      builder: (context, viewModel) {
        final accessories = viewModel.pieces.map((a) => new PieceTile(piece: a));

        return new Scaffold(
          body: new NestedScrollView(
            headerSliverBuilder: (context, isScrolled) {
              return <Widget>[
                new SliverAppBar(
                  expandedHeight: 256.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: new FlexibleSpaceBar(
                    background: new Image.file(new File(viewModel.outfit.image), fit: BoxFit.cover),
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
                  title: new Text(viewModel.outfit.name, style: Theme.of(context).textTheme.title),
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

class _OutfitPageViewModel {
  _OutfitPageViewModel({
    this.outfit,
    this.pieces
  });

  final Outfit outfit;
  final BuiltList<Piece> pieces;

  factory _OutfitPageViewModel.create(Store<AppState> store) {
    return new _OutfitPageViewModel(
      outfit: store.state.outfits.current,
      pieces: new BuiltList<Piece>(store.state.outfits.current.pieces.map((id) => store.state.pieces.firstWhere((p) => p.id == id)))
    );
  }

  @override
  operator ==(o) =>
    identical(this, o) ||
    o is _OutfitPageViewModel &&
    outfit == o.outfit &&
    pieces == o.pieces;

  @override
  int get hashCode =>
    this.outfit.hashCode ^
    this.pieces.hashCode;
}