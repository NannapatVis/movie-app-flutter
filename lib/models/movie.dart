class Movie {
  final String imageUrl;
  final String name;
  final double rating;
  final DateTime watchedDate;
  final String? description;  // เพิ่มคำอธิบายเพิ่มเติม

  Movie({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.watchedDate,
    this.description,  // ให้ค่า description เป็น null ได้
  });
}
