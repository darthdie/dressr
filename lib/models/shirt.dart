class Shirt {
  Shirt({
    this.name,
    this.image,
  });

  final String name;
  final String image;

  Shirt copyWith({
    String name,
    String image,
  }) {
    return new Shirt(
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}