import 'package:built_collection/built_collection.dart';
import 'package:uuid/uuid.dart';

enum PieceType {
  Shirt,
  Accessory
}

class Piece {
  Piece(this.type, {
    String id,
    this.name,
    this.image,
    bool buttonable,
    BuiltList<String> pieces
  }):
    this.id = id ?? new Uuid().v4();

  final PieceType type;

  final String name;
  final String image;
  final String id;

  Map toJson() {
    return {
      'type': type.toString(),
      'name': name,
      'image': image,
    };
  }
}