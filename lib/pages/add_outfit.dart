import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:dressr/app_state.dart';
import 'package:dressr/models/outfit.dart';
import 'package:dressr/models/piece.dart';
import 'package:dressr/pages/select_piece/select_piece.dart';
import 'package:dressr/widgets/piece_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

class AddOutfitModal extends StatelessWidget {
  Widget _thumbnailWidget(BuildContext context, _AddOutfitModalViewModel viewModel) {
    final menuButtons = [
      new PopupMenuItem(
        child: new Row(
          children: <Widget>[
            const Icon(Icons.photo_library),
            const SizedBox(width: 8.0),
            const Expanded(child: const Text('Select From Library'))
          ],
        ),
        value: ImageSource.gallery,
      ),
      new PopupMenuItem(
        child: new Row(
          children: <Widget>[
            const Icon(Icons.camera),
            const SizedBox(width: 8.0),
            const Expanded(child: const Text('Take Picture'))
          ],
        ),
        value: ImageSource.camera
      )
    ];

    final image = (viewModel.outfit.image ?? '').isEmpty
      ? new CircleAvatar(
        child: const Icon(Icons.image, size: 128.0),
        backgroundColor: Colors.grey.shade300,
        foregroundColor: Colors.grey.shade600,
        radius: 128.0,
      )
      : new Container(
        width: 256.0,
        height: 256.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: new FileImage(new File(viewModel.outfit.image))
          )
        )
      );

    return PopupMenuButton<ImageSource>(
      padding: const EdgeInsets.all(64.0),
      child: new Padding(
        padding: const EdgeInsets.all(12.0),
        child: image,
      ),
      itemBuilder: (context) {
        return menuButtons;
      },
      onSelected: (source) async {
        final image = await ImagePicker.pickImage(source: source);
        if (image != null) {
          viewModel.updateOutfit(viewModel.outfit.copyWith(image: image.path));
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, _AddOutfitModalViewModel viewModel) {
    final pieces = viewModel.pieces.map((p) {
      return new PieceTile(
        piece: p,
        trailing: new IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            viewModel.updateOutfit(viewModel.outfit.copyWith(pieces: viewModel.outfit.pieces.rebuild((b) => b..remove(p.id))));
          },
        ),
      );
    });

    final addPieceButton = new FlatButton(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Add'),
          const Icon(Icons.add),
        ],
      ),
      onPressed: () async {
        final id = await await Navigator.push(context, new MaterialPageRoute(builder: (ctx) => new SelectPieceModal()));
        if (id != null) {
          viewModel.updateOutfit(viewModel.outfit.copyWith(pieces: viewModel.outfit.pieces.rebuild((b) => b..add(id))));
        }
      }
    );

    return new Container(
      child: new ListView(
        children: <Widget>[
          new Center(child: _thumbnailWidget(context, viewModel)),
          const Divider(),
          new ListTile(
            title: new TextField(
              decoration: new InputDecoration(hintText: 'Name'),
              onChanged: (value) => viewModel.updateOutfit(viewModel.outfit.copyWith(name: value))
            ),
          ),
          new ListTile(
            title: Text('Pieces...', style: Theme.of(context).textTheme.title),
          ),
          const Divider(),
        ]
        ..addAll(pieces)
        ..addAll([addPieceButton])
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _AddOutfitModalViewModel>(
      distinct: true,
      converter: (store) => new _AddOutfitModalViewModel.create(store),
      builder: (context, viewModel) {
        final addButton = new Builder(
          builder: (context) {
            return new IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final error = _validateNewAccessory(viewModel);

                if (error == null) {
                  viewModel.addOutfit();
                  Navigator.of(context).pop();
                } else {
                  final snackBar = SnackBar(content: new Text(error));
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              },
            );
          },
        );

        return new Scaffold(
          appBar: new AppBar(
            title: const Text('Add Outfit'),
            actions: <Widget>[addButton],
          ),
          body: _buildBody(context, viewModel),
        );
      },
    );
  }

  String _validateNewAccessory(_AddOutfitModalViewModel viewModel) {
    if ((viewModel.outfit.image ?? '').isEmpty) {
      return 'Please select an image.';
    }

    if ((viewModel.outfit.name ?? '').isEmpty) {
      return 'Please enter in a name';
    }

    return null;
  }
}

class _AddOutfitModalViewModel {
  _AddOutfitModalViewModel({
    this.pieces,
    this.outfit,
    this.updateOutfit,
    this.addOutfit,
  });

  final BuiltList<Piece> pieces;
  final UpdateOutfitCallback updateOutfit;
  final Outfit outfit;
  final Function addOutfit;

  factory _AddOutfitModalViewModel.create(Store<AppState> store) {
    return new _AddOutfitModalViewModel(
      pieces: new BuiltList<Piece>(store.state.outfits.current.pieces.map<Piece>((id) => store.state.getPiece(id))),
      updateOutfit: (outfit) => store.dispatch(new SetCurrentOutfit(outfit)),
      outfit: store.state.outfits.current,
      addOutfit: () => store.dispatch(new AddOrUpdateOutfit(store.state.outfits.current)),
    );
  }

  @override
  operator ==(o) =>
    identical(this, o) ||
    o is _AddOutfitModalViewModel &&
    pieces == o.pieces &&
    outfit == o.outfit;

  @override
  int get hashCode =>
    pieces.hashCode ^
    outfit.hashCode;
}

typedef PieceCallback = Function(String);
typedef UpdateOutfitCallback = Function(Outfit);