class VehicleModel {
  final int id;

  final int userId;

  final String vehicleType;

  final String makeModel;

  final String licensePlate;

  final bool isElectric;

  final String color;

  final bool isDefault;

  VehicleModel({
    required this.id,
    required this.userId,
    required this.vehicleType,
    required this.makeModel,
    required this.licensePlate,
    required this.isElectric,
    required this.color,
    required this.isDefault,
  });

  factory VehicleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return VehicleModel(
      id: json["id"],
      userId: json["user_id"],
      vehicleType: json["vehicle_type"],
      makeModel: json["make_model"],
      licensePlate: json["license_plate"],
      isElectric: json["is_electric"],
      color: json["color"],
      isDefault: json["is_default"],
    );
  }
}