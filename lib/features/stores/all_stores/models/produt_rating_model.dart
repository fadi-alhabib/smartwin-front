class RatingModel {
  String? message;
  Rating? rating;

  RatingModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    rating = Rating.fromJson(json["rating"]);
  }
}

class Rating {
  int? id;
  String? name;
  String? description;
  String? price;
  String? image;
  int? storeId;
  String? createdAt;
  String? updatedAt;
  int? rating;
  int? ratingsCount;

  Rating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    rating = json['rating'];
    ratingsCount = json['ratings_count'];
  }
}
