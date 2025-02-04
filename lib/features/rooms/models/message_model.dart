class MessageModel {
  int? id;
  String? message;
  String? senderName;
  int? senderId;
  String? sentAt;

  MessageModel(
      {this.id, this.message, this.senderName, this.senderId, this.sentAt});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    senderName = json['sender_name'];
    senderId = json['sender_id'];
    sentAt = json['sent_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['sender_name'] = senderName;
    data['sender_id'] = senderId;
    data['sent_at'] = sentAt;
    return data;
  }
}
