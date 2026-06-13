class ListingModel {
  final int id;
  final int ownerId;
  final String title;
  final String address;
  final double latitude;
  final double longitude;
  final double hourlyRate;
  final int totalSpaces;
  final int availableSpaces;
  final String? description;
  final bool isActive;

  ListingModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.hourlyRate,
    required this.totalSpaces,
    required this.availableSpaces,
    required this.description,
    required this.isActive,
  });

  factory ListingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ListingModel(
      id: json["id"],
      ownerId: json["owner_id"],
      title: json["title"],
      address: json["address"],
      latitude:
          json["latitude"].toDouble(),
      longitude:
          json["longitude"].toDouble(),
      hourlyRate:
          json["hourly_rate"].toDouble(),
      totalSpaces:
          json["total_spaces"],
      availableSpaces:
          json["available_spaces"],
      description:
          json["description"],
      isActive:
          json["is_active"],
    );
  }
}