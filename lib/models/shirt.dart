import 'package:built_collection/built_collection.dart';

class Shirt {
  Shirt({
    this.name,
    this.image,
    bool buttonable,
    BuiltList<String> accessories
  }):
    this.accessories = accessories ?? new BuiltList(),
    this.buttonable = buttonable ?? false;

  final String name;
  final String image;
  final bool buttonable;
  final BuiltList<String> accessories;

  Shirt copyWith({
    String name,
    String image,
    bool buttonable,
    BuiltList<String> accessories,
  }) {
    return new Shirt(
      name: name ?? this.name,
      image: image ?? this.image,
      buttonable: buttonable ?? this.buttonable,
      accessories: accessories ?? this.accessories
    );
  }

  Map toJson() {
    return {
      'name': name,
      'image': image,
      'buttonable': buttonable,
      'accessories': accessories.toList(),
    };
  }

  factory Shirt.fromJson(Map json) {
    return new Shirt(
      name: json['name'],
      image: json['image'],
      buttonable: json['buttonable'],
      accessories: new BuiltList(json['accessories'])
    );
  }
}