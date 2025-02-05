import 'package:sw/features/rooms/models/answer_model.dart';

class QuestionModel {
  int? id;
  String? title;
  List<AnswerModel>? answers;
  String? image;
  QuestionModel({this.id, this.title, this.answers, this.image});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    List<dynamic>? answersJson = json['answers'];
    if (answersJson != null) {
      answers = <AnswerModel>[];
      answersJson.shuffle();
      for (var v in answersJson) {
        answers!.add(AnswerModel.fromJson(v));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
