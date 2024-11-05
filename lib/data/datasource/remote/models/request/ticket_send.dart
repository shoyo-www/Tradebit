import 'dart:convert';

String ticketSendRequestToJson(TicketSendRequest data) => json.encode(data.toJson());

class TicketSendRequest {
  final String comment;
  final int categoryId;
  final int ticketId;

  TicketSendRequest({
    required this.comment,
    required this.categoryId,
    required this.ticketId,
  });


  Map<String, dynamic> toJson() => {
    "comment": comment,
    "category_id": categoryId,
    "ticket_id": ticketId,
  };
}
