import 'package:uuid/uuid.dart';

class Accessory {
  Accessory({
    String id,
    this.name,
    this.image,
  }):
    this.id = id ?? new Uuid().v4();

  final String name;
  final String image;
  final String id;

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

  Map toJson() {
    return {
      'name': name,
      'image': image,
      'id': id
    };
  }

  factory Accessory.fromJson(Map json) {
    return new Accessory(
      name: json['name'],
      image: json['image'],
      id: json['id'],
    );
  }
}