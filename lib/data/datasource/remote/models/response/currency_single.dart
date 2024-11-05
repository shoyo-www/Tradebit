import 'dart:convert';

CurrencyResponse currencyResponseFromJson(String str) => CurrencyResponse.fromJson(json.decode(str));


class CurrencyResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  CurrencyResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) => CurrencyResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final String? currency;
  final Wallets? wallets;

  Data({
    this.currency,
    this.wallets,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currency: json["currency"],
    wallets: json["wallets"] == null ? null : Wallets.fromJson(json["wallets"]),
  );

}

class Wallets {
  final Freezed? spot;
  final Freezed? fund;
  final Freezed? freezed;

  Wallets({
    this.spot,
    this.fund,
    this.freezed,
  });

  factory Wallets.fromJson(Map<String, dynamic> json) => Wallets(
    spot: json["spot"] == null ? null : Freezed.fromJson(json["spot"]),
    fund: json["fund"] == null ? null : Freezed.fromJson(json["fund"]),
    freezed: json["freezed"] == null ? null : Freezed.fromJson(json["freezed"]),
  );

}

class Freezed {
  final String? quantity;

  Freezed({
    this.quantity,
  });

  factory Freezed.fromJson(Map<String, dynamic> json) => Freezed(
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "quantity": quantity,
  };
}
