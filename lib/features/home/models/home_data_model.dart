import 'package:sw/features/home/models/ads_model.dart';

class HomeDataModel {
  List<AdsModel>? ads;
  int? points;
  String? availableTime;

  HomeDataModel({this.ads, this.points, this.availableTime});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    if (json['ads'] != null) {
      ads = <AdsModel>[];
      json['ads'].forEach((v) {
        ads!.add(AdsModel.fromJson(v));
      });
    }
    points = json['points'];
    availableTime = json['available_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ads != null) {
      data['ads'] = ads!.map((v) => v.toJson()).toList();
    }
    data['points'] = points;
    data['available_time'] = availableTime;
    return data;
  }
}
