import 'dart:convert';

OrderHistory orderHistoryFromJson(String str) => OrderHistory.fromJson(json.decode(str));

class OrderHistory {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  OrderHistory({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final int? currentPage;
  final List<OrderHistoryResponse>? data;
  final int? from;
  final int? to;
  final int? lastPage;
  final int? perPage;
  final int? total;

  Data({
    this.currentPage,
    this.data,
    this.from,
    this.to,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<OrderHistoryResponse>.from(json["data"]!.map((x) => OrderHistoryResponse.fromJson(x))),
    from: json["from"],
    to: json["to"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );

}

class OrderHistoryResponse {
  final int? id;
  final int? userId;
  final String? currency;
  final String? withCurrency;
  final String? atPrice;
  final String? quantity;
  final String? total;
  final String? orderType;
  final String? type;
  final String? pendingQty;
  final String? stopPrice;
  final String? currentStatus;
  final String? commission;
  final dynamic commissionCurrency;
  final dynamic bOrderid;
  final String? extra;
  final dynamic newClientOrderId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderHistoryResponse({
    this.id,
    this.userId,
    this.currency,
    this.withCurrency,
    this.atPrice,
    this.quantity,
    this.total,
    this.orderType,
    this.type,
    this.pendingQty,
    this.stopPrice,
    this.currentStatus,
    this.commission,
    this.commissionCurrency,
    this.bOrderid,
    this.extra,
    this.newClientOrderId,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) => OrderHistoryResponse(
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
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

}


