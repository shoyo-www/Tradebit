import 'dart:convert';

TicketResponse ticketResponseFromJson(String str) => TicketResponse.fromJson(json.decode(str));


class TicketResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  TicketResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory TicketResponse.fromJson(Map<String, dynamic> json) => TicketResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final List<Ticket>? tickets;
  final int? totalTickets;
  final int? totalInprocess;
  final int? totalClose;

  Data({
    this.tickets,
    this.totalTickets,
    this.totalInprocess,
    this.totalClose,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tickets: json["tickets"] == null ? [] : List<Ticket>.from(json["tickets"]!.map((x) => Ticket.fromJson(x))),
    totalTickets: json["total_tickets"],
    totalInprocess: json["total_inprocess"],
    totalClose: json["total_close"],
  );

  Map<String, dynamic> toJson() => {
    "tickets": tickets == null ? [] : List<dynamic>.from(tickets!.map((x) => x.toJson())),
    "total_tickets": totalTickets,
    "total_inprocess": totalInprocess,
    "total_close": totalClose,
  };
}

class Ticket {
  final String? authorEmail;
  final String? categoryId;
  final String? authorName;
  final String? content;
  final DateTime? createdAt;
  final int? id;
  final String? status;
  final String? title;
  final Category? category;

  Ticket({
    this.authorEmail,
    this.categoryId,
    this.authorName,
    this.content,
    this.createdAt,
    this.id,
    this.status,
    this.title,
    this.category,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    authorEmail: json["author_email"],
    categoryId: json["category_id"],
    authorName: json["author_name"],
    content: json["content"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
    status: json["status"],
    title: json["title"],
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "author_email": authorEmail,
    "category_id": categoryId,
    "author_name": authorName,
    "content": content,
    "created_at": createdAt?.toIso8601String(),
    "id": id,
    "status": status,
    "title": title,
    "category": category?.toJson(),
  };
}

class Category {
  final int? id;
  final String? name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
