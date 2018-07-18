import 'dart:io';

import 'package:dressr/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:image_picker/image_picker.dart';

class AddShirtModal extends StatelessWidget {
  Widget _thumbnailWidget(BuildContext context, _AddShirtViewModel viewModel) {
    if (viewModel.image != null) {
      return new SizedBox(
        child: new Image.file(new File(viewModel.image)),
        width: 32.0,
        height: 32.0,
      );
    }

    return PopupMenuButton<ImageSource>(
      child: new CircleAvatar(
        child: const Icon(Icons.image, size: 32.0),
        backgroundColor: Colors.grey.shade300,
        foregroundColor: Colors.grey.shade600,
      ),
      itemBuilder: (context) {
        return [
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
          new ListTile(
            leading: _thumbnailWidget(context, viewModel),
            title: new TextField(
              decoration: new InputDecoration(hintText: 'Name'),
              onSubmitted: (value) {
                print(value);
              },
            ),
          ),
          new CheckboxListTile(
            value: false,
            title: const Text('Buttonable'),
            onChanged: (value) {
            },
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
        return new Scaffold(
          appBar: new AppBar(
            title: const Text('Add Shirt'),
            actions: <Widget>[
              new FlatButton(
                child: new IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                  },
                ),
                onPressed: () async {
                  // _formKey.currentState.validate();
                },
              )
            ],
          ),
          body: _buildBody(context, viewModel),
        );
      }
    );
  }
}

class _AddShirtViewModel {
  _AddShirtViewModel({
    this.name,
    this.image,
    this.buttonable,
    this.updateImage
  });

  final String name;
  final String image;
  final bool buttonable;
  final UpdateImageCallback updateImage;

  factory _AddShirtViewModel.create(Store<AppState> store) {
    return new _AddShirtViewModel(
      name: '',
      image: store.state.newShirtImage,
      buttonable: false,
      updateImage: (image) => store.dispatch(new UpdateNewShirtImage(image))
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

// class CameraPreviewModal extends StatefulWidget {
//   CameraPreviewModal(this.cameras);

//   final List<CameraDescription> cameras;

//   @override
//   _CameraPreviewModalState createState() => new _CameraPreviewModalState(this.cameras);
// }

// class _CameraPreviewModalState extends State<CameraPreviewModal> {
//   _CameraPreviewModalState(this.cameras);

//   final List<CameraDescription> cameras;

//   CameraController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = new CameraController(cameras[0], ResolutionPreset.medium);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }

//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return new Container();
//     }

//     return new Material(
//       child: new Column(
//         children: <Widget>[
//           new AspectRatio(
//             aspectRatio: controller.value.aspectRatio,
//             child: new CameraPreview(controller)),
//           _captureControlRowWidget()
//         ],
//       )
//     );
//   }

//   Widget _captureControlRowWidget() {
//     return new Container(
//       height: 47.0,
//       child: new Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           new IconButton(
//             icon: const Icon(Icons.camera_alt),
//             color: Colors.blue,
//             onPressed: controller != null &&
//                     controller.value.isInitialized &&
//                     !controller.value.isRecordingVideo
//                 ? onTakePictureButtonPressed
//                 : null,
//           ),
//         ],
//       )
//     );
//   }

//   void onTakePictureButtonPressed() {
//     takePicture().then((String filePath) {
//       if (mounted && filePath != null) {
//         Navigator.pop(context, filePath);
//       }
//     });
//   }

//   Future<String> takePicture() async {
//     final Directory extDir = await getApplicationDocumentsDirectory();
//     final String dirPath = '${extDir.path}/Pictures/flutter_test';
//     await new Directory(dirPath).create(recursive: true);
//     final String filePath = '$dirPath/${timestamp()}.jpg';

//     if (controller.value.isTakingPicture) {
//       return null;
//     }

//     try {
//       await controller.takePicture(filePath);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return null;
//     }

//     return filePath;
//   }

//   void _showCameraException(CameraException e) {
//     print(e);
//     // showInSnackBar('Error: ${e.code}\n${e.description}');
//   }

//   String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();
// }