class Shirt {
  Shirt({
    this.name,
    this.image,
    this.buttonable,
  });

  final String name;
  final String image;
  final bool buttonable;

  Shirt copyWith({
    String name,
    String image,
    bool buttonable,
  }) {
    return new Shirt(
      name: name ?? this.name,
      image: image ?? this.image,
      buttonable: buttonable ?? this.buttonable
    );
  }

  Map toJson() {
    return {
      'name': name,
      'image': image,
      'buttonable': buttonable
    };
  }

  factory Shirt.fromJson(Map json) {
    return new Shirt(
      name: json['name'],
      image: json['image'],
      buttonable: json['buttonable']
    );
  }
}