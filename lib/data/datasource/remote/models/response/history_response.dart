import 'dart:convert';

HistoryResponse historyResponseFromJson(String str) => HistoryResponse.fromJson(json.decode(str));

class HistoryResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  HistoryResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) => HistoryResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final int? currentPage;
  final List<Datum>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

}

class Datum {
  final int? id;
  final dynamic amount;
  final String? symbol;
  final String? userId;
  final String? userWalletAddress;
  final String? chainType;
  final String? tokenType;
  final String? tokenAddress;
  final String? status;
  final dynamic extra;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? currency;

  Datum({
    this.id,
    this.amount,
    this.symbol,
    this.userId,
    this.userWalletAddress,
    this.chainType,
    this.tokenType,
    this.tokenAddress,
    this.status,
    this.extra,
    this.createdAt,
    this.updatedAt,
    this.currency,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    amount: json["amount"],
    symbol: json["symbol"],
    userId: json["user_id"],
    userWalletAddress: json["user_wallet_address"],
    chainType: json["chain_type"],
    tokenType: json["token_type"],
    tokenAddress: json["token_address"],
    status: json["status"],
    extra: json["extra"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    currency: json["currency"],
  );

}
class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

}

