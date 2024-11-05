import 'dart:convert';

TicketSupport ticketSupportFromJson(String str) => TicketSupport.fromJson(json.decode(str));


class TicketSupport {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  TicketSupport({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory TicketSupport.fromJson(Map<String, dynamic> json) => TicketSupport(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final String? authorEmail;
  final String? authorName;
  final String? content;
  final DateTime? createdAt;
  final int? id;
  final String? status;
  final String? title;
  final List<Comment>? comments;

  Data({
    this.authorEmail,
    this.authorName,
    this.content,
    this.createdAt,
    this.id,
    this.status,
    this.title,
    this.comments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    authorEmail: json["author_email"],
    authorName: json["author_name"],
    content: json["content"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
    status: json["status"],
    title: json["title"],
    comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
  );
}

class Comment {
  final int? id;
  final String? ticketId;
  final String? comment;
  final String? commentedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  Comment({
    this.id,
    this.ticketId,
    this.comment,
    this.commentedBy,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    ticketId: json["ticket_id"],
    comment: json["comment"],
    commentedBy: json["commented_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]));

}

class User {
  final int? id;
  final String? name;
  final String? userKycStatus;
  final String? userKycStatusMessage;
  final bool? isReward;
  final dynamic rewards;

  User({
    this.id,
    this.name,
    this.userKycStatus,
    this.userKycStatusMessage,
    this.isReward,
    this.rewards,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    userKycStatus: json["user_kyc_status"],
    userKycStatusMessage: json["user_kyc_status_message"],
    isReward: json["is_reward"],
    rewards: json["rewards"],
  );

}
