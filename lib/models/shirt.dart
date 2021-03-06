import 'package:dressr/models/piece.dart';

class Shirt extends Piece {
  Shirt({
    String id,
    String name,
    String image,
    bool buttonable,
  }): 
    this.buttonable = buttonable ?? false,
    super(PieceType.Shirt, id: id, name: name, image: image);

  final bool buttonable;

  Shirt copyWith({
    String name,
    String image,
    bool buttonable,
  }) {
    return new Shirt(
      id: id,
      name: name ?? this.name,
      image: image ?? this.image,
      buttonable: buttonable ?? this.buttonable,
    );
  }

  Map toJson() {
    return super.toJson()
    ..addAll({
      'buttonable': buttonable,
    });
  }

  factory Shirt.fromJson(Map json) {
    return new Shirt(
      name: json['name'],
      image: json['image'],
      buttonable: json['buttonable'],
    );
  }
}