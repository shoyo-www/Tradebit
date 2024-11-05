import 'dart:convert';

WithdrawRequestResponse withdrawRequestResponseFromJson(String str) => WithdrawRequestResponse.fromJson(json.decode(str));

class WithdrawRequestResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  WithdrawRequestResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory WithdrawRequestResponse.fromJson(Map<String, dynamic> json) => WithdrawRequestResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final String? tokenType;
  final double? amount;
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
    amount: json["amount"]?.toDouble(),
    toAddress: json["toAddress"],
    currency: json["currency"],
  );

}
