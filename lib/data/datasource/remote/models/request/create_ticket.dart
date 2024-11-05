import 'dart:convert';

String createTicketToJson(CreateTicket data) => json.encode(data.toJson());

class CreateTicket {
  final String? title;
  final int? categoryId;
  final String? authorName;
  final String? authorEmail;
  final String? content;

  CreateTicket({
    this.title,
    this.categoryId,
    this.authorName,
    this.authorEmail,
    this.content,
  });


  Map<String, dynamic> toJson() => {
    "title": title,
    "category_id": categoryId,
    "author_name": authorName,
    "author_email": authorEmail,
    "content": content,
  };
}
