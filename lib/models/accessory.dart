import 'package:dressr/models/piece.dart';

class Accessory extends Piece {
  Accessory({
    String id,
    String name,
    String image,
  }): super(PieceType.Accessory, id: id, name: name, image: image);

  Accessory copyWith({
    String name,
    String image,
  }) {
    return new Accessory(
      id: id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  factory Accessory.fromJson(Map json) {
    return new Accessory(
      name: json['name'],
      image: json['image'],
      id: json['id'],
    );
  }
}