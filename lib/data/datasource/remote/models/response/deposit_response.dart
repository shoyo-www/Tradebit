import 'dart:convert';

DepositResponse depositResponseFromJson(String str) => DepositResponse.fromJson(json.decode(str));

class DepositResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final List<dynamic>? data;

  DepositResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory DepositResponse.fromJson(Map<String, dynamic> json) => DepositResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
  );

}
