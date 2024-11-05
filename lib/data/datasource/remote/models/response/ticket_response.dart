import 'dart:convert';

TicketTypeResponse ticketTypeResponseFromJson(String str) => TicketTypeResponse.fromJson(json.decode(str));

class TicketTypeResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final List<TicketType>? data;

  TicketTypeResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory TicketTypeResponse.fromJson(Map<String, dynamic> json) => TicketTypeResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? [] : List<TicketType>.from(json["data"]!.map((x) => TicketType.fromJson(x))),
  );

}

class TicketType {
  final int? id;
  final String? name;
  final String? createdBy;
  final DateTime? createdAt;
  final dynamic updatedAt;

  TicketType({
    this.id,
    this.name,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) => TicketType(
    id: json["id"],
    name: json["name"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

}
