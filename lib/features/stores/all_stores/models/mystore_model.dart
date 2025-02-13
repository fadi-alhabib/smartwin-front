class UeserStoreModle {
  Store? store;

  UeserStoreModle({this.store});

  UeserStoreModle.fromJson(Map<String, dynamic> json) {
    store = Store.fromJson(json["data"]);
  }
}

class Store {
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
  List<Products> products = [];

  Store.fromJson(Map<String, dynamic> json) {
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

    json["products"].forEach((element) {
      products.add(Products.fromJson(element));
    });
  }
}

class Products {
  int? id;
  String? name;
  String? description;
  String? price;
  List<Images>? images;
  Null averageRating;
  bool? userHasRated;

  Products(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.images,
      this.averageRating,
      this.userHasRated});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    averageRating = json['average_rating'];
    userHasRated = json['user_has_rated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['average_rating'] = averageRating;
    data['user_has_rated'] = userHasRated;
    return data;
  }
}

class Images {
  int? id;
  String? image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}
