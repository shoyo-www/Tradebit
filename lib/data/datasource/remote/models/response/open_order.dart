import 'dart:convert';

OpenOrderResponse openOrderResponseFromJson(String str) => OpenOrderResponse.fromJson(json.decode(str));


class OpenOrderResponse {
  String statusCode;
  String statusText;
  String message;
  Data data;

  OpenOrderResponse({
    required this.statusCode,
    required this.statusText,
    required this.message,
    required this.data,
  });

  factory OpenOrderResponse.fromJson(Map<String, dynamic> json) => OpenOrderResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

}

class Data {
  int currentPage;
  List<OpenOrder> data;
  int from;
  int to;
  int lastPage;
  int perPage;
  int total;

  Data({
    required this.currentPage,
    required this.data,
    required this.from,
    required this.to,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<OpenOrder>.from(json["data"].map((x) => OpenOrder.fromJson(x))),
    from: json["from"] == null ? 0 : json["from"],
    to: json["to"] == null ? 0 : json["to"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );

}

class OpenOrder {
  int id;
  int userId;
  String currency;
  String withCurrency;
  String atPrice;
  String quantity;
  String total;
  String orderType;
  String type;
  String pendingQty;
  String stopPrice;
  String currentStatus;
  String commission;
  dynamic commissionCurrency;
  dynamic bOrderid;
  String extra;
  dynamic newClientOrderId;
  DateTime createdAt;
  DateTime updatedAt;

  OpenOrder({
    required this.id,
    required this.userId,
    required this.currency,
    required this.withCurrency,
    required this.atPrice,
    required this.quantity,
    required this.total,
    required this.orderType,
    required this.type,
    required this.pendingQty,
    required this.stopPrice,
    required this.currentStatus,
    required this.commission,
    required this.commissionCurrency,
    required this.bOrderid,
    required this.extra,
    required this.newClientOrderId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OpenOrder.fromJson(Map<String, dynamic> json) => OpenOrder(
    id: json["id"],
    userId: json["user_id"],
    currency: json["currency"],
    withCurrency: json["with_currency"],
    atPrice: json["at_price"],
    quantity: json["quantity"],
    total: json["total"],
    orderType: json["order_type"],
    type: json["type"],
    pendingQty: json["pending_qty"],
    stopPrice: json["stop_price"],
    currentStatus: json["current_status"],
    commission: json["commission"],
    commissionCurrency: json["commission_currency"],
    bOrderid: json["b_orderid"],
    extra: json["extra"],
    newClientOrderId: json["new_client_order_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

}
