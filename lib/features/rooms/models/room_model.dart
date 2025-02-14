// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:sw/common/utils/cache_helper.dart';
import 'package:sw/features/auth/models/user_model.dart';

class RoomModel {
  int? id;
  String? name;
  String? image;
  int? online;
  int? availableTime;
  int? hostId;
  bool? isHost;

  RoomModel({
    this.id,
    this.name,
    this.image,
    this.online,
    this.availableTime,
    this.hostId,
  });

  RoomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    online = json['online'];
    availableTime = json['available_time'];
    hostId = json['host_id'];
    final UserModel user = UserModel.fromJson(
      jsonDecode(CacheHelper.getCache(key: 'user')),
    );
    isHost = user.id == hostId;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['online'] = online;
    data['available_time'] = availableTime;
    data['host_id'] = hostId;
    return data;
  }
}

enum GamesEnum {
  quiz(1),
  c4(2);

  final int value;
  const GamesEnum(this.value);
}

extension GamesExtension on GamesEnum {
  String get asString {
    return toString().split('.').last;
  }
}
