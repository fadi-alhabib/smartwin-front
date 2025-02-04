class RoomModel {
  int? id;
  String? name;
  String? image;
  int? online;
  int? availableTime;

  RoomModel({this.id, this.name, this.image, this.online, this.availableTime});

  RoomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    online = json['online'];
    availableTime = json['available_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['online'] = online;
    data['available_time'] = availableTime;
    return data;
  }
}

enum GamesEnum {
  quiz(1),
  images(2),
  c4(3);

  final int value;
  const GamesEnum(this.value);
}

extension GamesExtension on GamesEnum {
  String get asString {
    return toString().split('.').last;
  }
}
