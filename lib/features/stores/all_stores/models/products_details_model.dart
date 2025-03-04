// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  Store? store;
  int? averageRating;
  bool? userHasRated;
  int? yourRating;
  List<ImageModel> images = [];

  Product.fromJson(Map<String, dynamic> json) {
    print("json: $json");
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'].toString();
    store = Store.fromJson(json['store']);
    averageRating =
        json['average_rating'] != null ? (json['average_rating']) : null;
    userHasRated = json['user_has_rated'];
    yourRating = json['your_rating'];
    if (json['images'] != null) {
      images = (json['images'] as List)
          .map((imageJson) => ImageModel.fromJson(imageJson))
          .toList();
    }
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, store: $store, averageRating: $averageRating, userHasRated: $userHasRated, yourRating: $yourRating,images: $images)';
  }
}

class Store {
  int? id;
  String? name;
  String? type;
  String? country;
  String? address;
  String? phone;
  String? owner;
  String? image;

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    country = json['country'];
    address = json['address'];
    phone = json['phone'];
    owner = json['owner'];
    image = json['image'];
  }
}

class ImageModel {
  int? id;
  String? imageUrl;

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image'];
  }
}
