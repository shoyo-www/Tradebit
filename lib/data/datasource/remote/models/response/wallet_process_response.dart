import 'dart:convert';

WalletProcessResponse walletProcessResponseFromJson(String str) => WalletProcessResponse.fromJson(json.decode(str));


class WalletProcessResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  WalletProcessResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory WalletProcessResponse.fromJson(Map<String, dynamic> json) => WalletProcessResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final String? tokenType;
  final String? amount;
  final String? toAddress;
  final String? currency;

  Data({
    this.tokenType,
    this.amount,
    this.toAddress,
    this.currency,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tokenType: json["token_type"],
    amount: json["amount"],
    toAddress: json["toAddress"],
    currency: json["currency"],
  );

}
