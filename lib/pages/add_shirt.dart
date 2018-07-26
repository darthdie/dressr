import 'dart:async';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:dressr/app_state.dart';
import 'package:dressr/models/accessory.dart';
import 'package:dressr/pages/add_accessory.dart';
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
        if (image != null) {
          viewModel.updateImage(image.path);
        }
      },
    );
  }

  Future<String> showAddAccessory(BuildContext context, _AddShirtViewModel viewModel) {
    return showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return new StoreConnector<AppState, BuiltList<Accessory>>(
          converter: (store) => new BuiltList(store.state.accessories.where((a) => !store.state.newShirt.accessories.contains(a.id))),
          builder: (context, accessories) {
            final accessoryWidgets = accessories.map((a) {
              return new ListTile(
                title: new Text(a.name),
                leading: new CircleAvatar(
                  backgroundImage: new FileImage(new File(a.image)),
                  radius: 28.0
                ),
                onTap: () {
                  Navigator.of(context).pop(a.id);
                },
              );
            }).toList();

            final addItemButton = new FlatButton(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Add New'),
                  const Icon(Icons.add),
                ]
              ),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (context) => new AddAccessoryModal()));
              }
            );

            return new ListView(
              children: <Widget>[
                new ListTile(
                  title: new Text('Accessories', style: Theme.of(context).textTheme.title),
                  subtitle: new Text('${accessories.length} Accessories'),
                )
              ]
              ..addAll(accessoryWidgets)
              ..add(addItemButton)
            );
          },
        );
      }
    );
  }

  Widget _buildBody(BuildContext context, _AddShirtViewModel viewModel) {
    final matchItems = viewModel.accessories.map((a) {
      return new ListTile(
        leading: new CircleAvatar(
          backgroundImage: new FileImage(new File(a.image)),
          radius: 28.0
        ),
        title: new Text(a.name),
        trailing: new IconButton(
          icon: new Icon(Icons.delete),
          onPressed: () {
            viewModel.removeAccessory(a.id);
          },
        ),
      );
    });

    final addItemButton = new FlatButton(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Add'),
          const Icon(Icons.add),
        ],
      ),
      onPressed: () async {
        final id = await showAddAccessory(context, viewModel);
        if (id != null) {
          viewModel.addAccessory(id);
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
              onChanged: (value) => viewModel.updateName(value)
            ),
          ),
          new CheckboxListTile(
            value: viewModel.buttonable,
            title: const Text('Buttonable'),
            onChanged: (value) => viewModel.updateButtonable(value)
          ),
          new ListTile(
            title: Text('Goes with...', style: Theme.of(context).textTheme.title),
          ),
          const Divider(),
        ]
        ..addAll(matchItems)
        ..add(addItemButton)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _AddShirtViewModel>(
      distinct: true,
      converter: (store) => _AddShirtViewModel.create(store),
      builder: (context, viewModel) {
        final addShirtButton = new Builder(
          builder: (context) {
            return new IconButton(
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
    if ((viewModel.image ?? '').isEmpty) {
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
    this.addShirt,
    this.accessories,
    this.addAccessory,
    this.removeAccessory,
  });

  final String name;
  final String image;
  final bool buttonable;
  final UpdateImageCallback updateImage;
  final UpdateNameCallback updateName;
  final UpdateButtonableCallback updateButtonable;
  final Function addShirt;
  final BuiltList<Accessory> accessories;
  final AddAccessoryToShirtCallback addAccessory;
  final RemoveAccessoryToShirtCallback removeAccessory;

  factory _AddShirtViewModel.create(Store<AppState> store) {
    return new _AddShirtViewModel(
      name: store.state.newShirt.name,
      image: store.state.newShirt.image,
      buttonable: store.state.newShirt.buttonable,
      accessories: new BuiltList<Accessory>(store.state.accessories.where((a) => store.state.newShirt.accessories.contains(a.id))),
      updateImage: (image) => store.dispatch(new UpdateNewShirtImage(image)),
      updateName: (name) => store.dispatch(new UpdateNewShirtName(name)),
      updateButtonable: (buttonable) => store.dispatch(new UpdateNewShirtButtonable(buttonable)),
      addShirt: () => store.dispatch(new AddShirtAction()),
      addAccessory: (id) => store.dispatch(new AddAccessoryToNewShirt(id)),
      removeAccessory: (id) => store.dispatch(new RemoveAccessoryToNewShirt(id)),
    );
  }

  @override
  operator ==(o) =>
    identical(o, this) ||
    o is _AddShirtViewModel &&
    name == o.name &&
    image == o.image &&
    buttonable == o.buttonable &&
    accessories == o.accessories;

  @override
  int get hashCode =>
    name.hashCode ^
    image.hashCode ^
    buttonable.hashCode ^
    accessories.hashCode;
}

typedef UpdateImageCallback = Function(String);
typedef UpdateNameCallback = Function(String);
typedef UpdateButtonableCallback = Function(bool);
typedef AddAccessoryToShirtCallback = Function(String);
typedef RemoveAccessoryToShirtCallback = Function(String);