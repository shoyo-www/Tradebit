import 'dart:convert';

StakeBalance stakeBalanceFromJson(String str) => StakeBalance.fromJson(json.decode(str));

class StakeBalance {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  StakeBalance({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory StakeBalance.fromJson(Map<String, dynamic> json) => StakeBalance(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final int? currentPage;
  final List<StakeBal>? data;
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
    data: json["data"] == null ? [] : List<StakeBal>.from(json["data"]!.map((x) => StakeBal.fromJson(x))),
    from: json["from"],
    to: json["to"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );


}

class StakeBal {
  final String? userId;
  final String? currency;
  final String? balance;
  final String? withdrawable;
  final String? currencyImage;

  StakeBal({
    this.userId,
    this.currency,
    this.balance,
    this.withdrawable,
    this.currencyImage,
  });

  factory StakeBal.fromJson(Map<String, dynamic> json) => StakeBal(
    userId: json["user_id"],
    currency: json["currency"],
    balance: json["balance"],
    withdrawable: json["withdrawable"],
    currencyImage: json["currency_image"],
  );

}
