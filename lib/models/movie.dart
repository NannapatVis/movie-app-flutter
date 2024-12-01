class Movie {
  late final String imageUrl;
  final String name;
  final double rating;
  final DateTime watchedDate;
  final String? description;  

  Movie({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.watchedDate,
    this.description,  
  });
}
