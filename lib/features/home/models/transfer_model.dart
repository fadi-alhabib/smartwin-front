class TransferModel {
  final int id;
  final int userId;
  final String country;
  final String phone;
  final int points;

  TransferModel({
    required this.id,
    required this.userId,
    required this.country,
    required this.phone,
    required this.points,
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      id: json['id'],
      userId: json['user_id'],
      country: json['country'],
      phone: json['phone'],
      points: json['points'],
    );
  }
}
