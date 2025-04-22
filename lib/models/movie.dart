class Movie {
  final String name;
  final double rating;
  final String? description;
  final String imageUrl;
  final DateTime watchedDate;

  Movie({
    required this.name,
    required this.rating,
    this.description,
    required this.imageUrl,
    required this.watchedDate,
  });
}
