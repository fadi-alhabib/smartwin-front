class AdsModel {
  String? title;
  String? path;
  int? isImage;

  AdsModel({this.title, this.path, this.isImage});

  AdsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    path = json['path'];
    isImage = json['is_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['path'] = path;
    data['is_image'] = isImage;
    return data;
  }
}
