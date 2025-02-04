class AnswerModel {
  int? id;
  String? title;
  bool? isCorrect;

  AnswerModel({this.title, this.id, this.isCorrect});

  AnswerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isCorrect = json['is_correct'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['is_correct'] = isCorrect;
    return data;
  }
}
