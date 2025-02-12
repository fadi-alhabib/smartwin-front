class StoreRatingModel {
  String? message;
  Rating? rating;

  StoreRatingModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    rating = Rating.fromJson(json['rating']);
  }
}

class Rating {
  int? id;
  String? name;
  String? type;
  String? country;
  String? address;
  String? phone;
  int? points;
  int? isActive;
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? image;
  int? rating;
  int? ratingsCount;

  Rating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    country = json['country'];
    address = json['address'];
    phone = json['phone'];
    points = json['points'];
    isActive = json['is_active'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    rating = json['rating'];
    ratingsCount = json['ratings_count'];
  }
}
