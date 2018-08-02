import 'dart:io';

import 'package:dressr/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:image_picker/image_picker.dart';

class AddAccessoryModal extends StatelessWidget {
  Widget _thumbnailWidget(BuildContext context, _AddAccessoryViewModel viewModel) {
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

    final image = viewModel.image.isEmpty
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
            image: new FileImage(new File(viewModel.image))
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
          viewModel.updateImage(image.path);
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, _AddAccessoryViewModel viewModel) {
    return new Container(
      child: new ListView(
        children: <Widget>[
          new Center(child: _thumbnailWidget(context, viewModel)),
          const Divider(),
          new ListTile(
            title: new TextField(
              decoration: new InputDecoration(hintText: 'Name'),
              onChanged: (value) => viewModel.updateName(value)
            ),
          ),
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _AddAccessoryViewModel>(
      distinct: true,
      converter: (store) => _AddAccessoryViewModel.create(store),
      builder: (context, viewModel) {
        final addButton = new Builder(
          builder: (context) {
            return new IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final error = _validateNewAccessory(viewModel);

                if (error == null) {
                  viewModel.addAccessory();
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
            title: const Text('Add Accessory'),
            actions: <Widget>[addButton],
          ),
          body: _buildBody(context, viewModel),
        );
      }
    );
  }

  String _validateNewAccessory(_AddAccessoryViewModel viewModel) {
    if (viewModel.image.isEmpty) {
      return 'Please select an image.';
    }

    if (viewModel.name.isEmpty) {
      return 'Please enter in a name';
    }

    return null;
  }
}

class _AddAccessoryViewModel {
  _AddAccessoryViewModel({
    this.name,
    this.image,
    this.updateImage,
    this.updateName,
    this.addAccessory,
  });

  final String name;
  final String image;
  final UpdateImageCallback updateImage;
  final UpdateNameCallback updateName;
  final Function addAccessory;

  factory _AddAccessoryViewModel.create(Store<AppState> store) {
    return new _AddAccessoryViewModel(
      name: store.state.newAccessory.name ?? '',
      image: store.state.newAccessory.image ?? '',
      updateImage: (image) => store.dispatch(new UpdateNewAccessoryImage(image)),
      updateName: (name) => store.dispatch(new UpdateNewAccessoryName(name)),
      addAccessory: () => store.dispatch(new AddOrUpdatePieceAction(store.state.newAccessory))
    );
  }

  @override
  operator ==(o) =>
    identical(o, this) ||
    o is _AddAccessoryViewModel &&
    name == o.name &&
    image == o.image;

  @override
  int get hashCode =>
    name.hashCode ^
    image.hashCode;
}

typedef UpdateImageCallback = Function(String);
typedef UpdateNameCallback = Function(String);