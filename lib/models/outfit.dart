import 'package:built_collection/built_collection.dart';
import 'package:uuid/uuid.dart';

class Outfit {
  Outfit({String id, this.name, BuiltList<String> pieces, this.image}):
    this.pieces = pieces ?? new BuiltList<String>(),
    this.id = id ?? new Uuid().v4();

  final String name;
  final BuiltList<String> pieces;
  final String image;
  final String id;

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'pieces': pieces.toList()
    };
  }

  factory Outfit.fromJson(dynamic json) {
    return new Outfit(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      pieces: new BuiltList<String>(json['pieces'])
    );
  }

  Outfit copyWith({
    String id,
    String name,
    BuiltList<String> pieces,
    String image,
  }) {
    return new Outfit(
      id: id ?? this.id,
      name: name ?? this.name,
      pieces: pieces ?? this.pieces,
      image: image ?? this.image
    );
  }
}