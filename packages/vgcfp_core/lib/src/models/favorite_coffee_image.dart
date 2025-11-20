class FavoriteCoffeeImage {
  const FavoriteCoffeeImage({
    required this.id,
    required this.sourceUrl,
    required this.localPath,
    required this.savedAt,
  });

  final String id;
  final String sourceUrl;
  final String localPath;
  final DateTime savedAt;

  factory FavoriteCoffeeImage.fromLocalImage(
    String id,
    String sourceUrl,
    String localPath,
    DateTime savedAt,
  ) {
    return FavoriteCoffeeImage(
      id: id,
      sourceUrl: sourceUrl,
      localPath: localPath,
      savedAt: savedAt,
    );
  }

  FavoriteCoffeeImage copyWith({
    String? id,
    String? sourceUrl,
    String? localPath,
    DateTime? savedAt,
  }) {
    return FavoriteCoffeeImage(
      id: id ?? this.id,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      localPath: localPath ?? this.localPath,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}
