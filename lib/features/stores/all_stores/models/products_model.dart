class AllProductsModel {
  List<Product> products = [];

  AllProductsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((element) {
        products.add(Product.fromJson(element));
      });
    }
  }
}

class Product {
  int? id;
  String? name;
  String? description;
  String? price;
  Store? store; // Store type
  List<ImageModel> images = [];

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];

    // Ensure store is a Map before trying to parse it
    if (json['store'] != null && json['store'] is Map<String, dynamic>) {
      store = Store.fromJson(json['store']);
    }

    if (json['images'] != null) {
      json['images'].forEach((image) {
        images.add(ImageModel.fromJson(image));
      });
    }
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
  List<Product> products = [];

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    country = json['country'];
    address = json['address'];
    phone = json['phone'];
    owner = json['owner'];
    image = json['image'];

    // If the store has products, you can parse them as well, if needed.
  }
}

class ImageModel {
  int? id;
  String? image;

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}
