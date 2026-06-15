class BookingModel {
  final int id;
  final int userId;
  final int listingId;

  final String startTime;
  final String endTime;

  final double totalCost;

  final String status;

  BookingModel({
    required this.id,
    required this.userId,
    required this.listingId,
    required this.startTime,
    required this.endTime,
    required this.totalCost,
    required this.status,
  });

  factory BookingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BookingModel(
      id: json["id"],
      userId: json["user_id"],
      listingId: json["listing_id"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      totalCost:
          json["total_cost"].toDouble(),
      status: json["status"],
    );
  }
}