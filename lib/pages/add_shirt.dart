import 'dart:io';

import 'package:dressr/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:image_picker/image_picker.dart';

class AddShirtModal extends StatelessWidget {
  Widget _thumbnailWidget(BuildContext context, _AddShirtViewModel viewModel) {
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

    final image = viewModel.image == null
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
        viewModel.updateImage(image.path);
      },
    );
  }

  Widget _buildBody(BuildContext context, _AddShirtViewModel viewModel) {
    return new Container(
      child: new ListView(
        children: <Widget>[
          new Center(
            child: _thumbnailWidget(context, viewModel),
          ),
          new ListTile(
            title: new TextField(
              decoration: new InputDecoration(hintText: 'Name'),
              onChanged: (value) {
                viewModel.updateName(value);
              },
            ),
          ),
          new CheckboxListTile(
            value: false,
            title: const Text('Buttonable'),
            onChanged: (value) => viewModel.updateButtonable(value)
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _AddShirtViewModel>(
      distinct: true,
      converter: (store) => _AddShirtViewModel.create(store),
      builder: (context, viewModel) {
        final addShirtButton = new IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            final error = _validateNewShirt(viewModel);

            if (error == null) {
              viewModel.addShirt();
              Navigator.of(context).pop();
            } else {
              final snackBar = SnackBar(content: new Text(error));
              Scaffold.of(context).showSnackBar(snackBar);
            }
          },
        );

        return new Scaffold(
          appBar: new AppBar(
            title: const Text('Add Shirt'),
            actions: <Widget>[
              addShirtButton
            ],
          ),
          body: _buildBody(context, viewModel),
        );
      }
    );
  }

  String _validateNewShirt(_AddShirtViewModel viewModel) {
    if (viewModel.image.isEmpty) {
      return 'Please select an image.';
    }

    if (viewModel.name.isEmpty) {
      return 'Please enter in a name';
    }

    return null;
  }
}

class _AddShirtViewModel {
  _AddShirtViewModel({
    this.name,
    this.image,
    this.buttonable,
    this.updateImage,
    this.updateName,
    this.updateButtonable,
    this.addShirt
  });

  final String name;
  final String image;
  final bool buttonable;
  final UpdateImageCallback updateImage;
  final UpdateNameCallback updateName;
  final UpdateButtonableCallback updateButtonable;
  final Function addShirt;

  factory _AddShirtViewModel.create(Store<AppState> store) {
    return new _AddShirtViewModel(
      name: store.state.newShirt.name,
      image: store.state.newShirt.image,
      buttonable: store.state.newShirt.buttonable,
      updateImage: (image) => store.dispatch(new UpdateNewShirtImage(image)),
      updateName: (name) => store.dispatch(new UpdateNewShirtName(name)),
      updateButtonable: (buttonable) => store.dispatch(new UpdateNewShirtButtonable(buttonable)),
      addShirt: () => store.dispatch(new AddShirtAction())
    );
  }

  @override
  operator ==(o) =>
    identical(o, this) ||
    o is _AddShirtViewModel &&
    name == o.name &&
    image == o.image &&
    buttonable == o.buttonable;

  @override
  int get hashCode =>
    name.hashCode ^
    image.hashCode ^
    buttonable.hashCode;
}

typedef UpdateImageCallback = Function(String);
typedef UpdateNameCallback = Function(String);
typedef UpdateButtonableCallback = Function(bool);