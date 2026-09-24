class Destination {
  final String id;
  final String name;
  final String country;
  final String description;
  final String imageUrl;
  final String category;
  final double rating;
  final double price;
  final List<String> highlights;
  final String bestTime;

  Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.price,
    required this.highlights,
    required this.bestTime,
  });
}