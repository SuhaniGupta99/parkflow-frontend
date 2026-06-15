class QRModel {
  final int listingId;

  final String entryQrPath;
  final String exitQrPath;

  QRModel({
    required this.listingId,
    required this.entryQrPath,
    required this.exitQrPath,
  });

  factory QRModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return QRModel(
      listingId: json["listing_id"],
      entryQrPath: json["entry_qr_path"],
      exitQrPath: json["exit_qr_path"],
    );
  }
}