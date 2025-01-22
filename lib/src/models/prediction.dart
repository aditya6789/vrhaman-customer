class Prediction {
  final String placeId;
  final String? description;
  bool isFavorite; // Add this field

  Prediction(
      {required this.placeId,
      this.description,
      this.isFavorite = false}); // Initialize it

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      placeId: json['place_id'],
      description: json['description'],
      isFavorite: false, // Default value
    );
  }
}
