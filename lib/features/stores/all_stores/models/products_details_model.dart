class ProductDetailsModel {
  Product? product;

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    product = Product.fromJson(json['data']);
  }
}

class Product {
  int? id;
  String? name;
  String? description;
  String? price;
  String? image;
  Store? store;
  List<dynamic> images = [];

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    store = Store.fromJson(json['store']);
    json['images'].forEach((element) {
      images.add(element["image"]);
    });
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
  }
}
