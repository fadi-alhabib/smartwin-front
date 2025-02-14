class UserModel {
  int? id;
  String? email;
  String? fullName;
  String? phone;
  String? country;
  int? points;
  String? inviteCode;
  String? createdAt;
  String? updatedAt;
  String? image;

  UserModel({
    this.id,
    this.email,
    this.fullName,
    this.phone,
    this.country,
    this.points,
    this.inviteCode,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['full_name'];
    phone = json['phone'];
    country = json['country'];
    points = json['points'];
    inviteCode = json['invite_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['full_name'] = fullName;
    data['phone'] = phone;
    data['country'] = country;
    data['points'] = points;
    data['invite_code'] = inviteCode;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image'] = image;
    return data;
  }
}
