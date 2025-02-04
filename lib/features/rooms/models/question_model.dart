import 'package:sw/features/rooms/models/answer_model.dart';

class QuestionModel {
  int? id;
  String? title;
  List<AnswerModel>? answers;

  QuestionModel({this.id, this.title, this.answers});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['answers'] != null) {
      answers = <AnswerModel>[];
      json['answers'].forEach((v) {
        answers!.add(AnswerModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
