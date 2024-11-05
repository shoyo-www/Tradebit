
import 'dart:convert';

BidsAndAsksResponse bidsAndAsksResponseFromJson(String str) => BidsAndAsksResponse.fromJson(json.decode(str));

class BidsAndAsksResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  BidsAndAsksResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory BidsAndAsksResponse.fromJson(Map<String, dynamic> json) => BidsAndAsksResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final int? lastUpdateId;
  final List<List<String>>? bids;
  final List<List<String>>? asks;

  Data({
    this.lastUpdateId,
    this.bids,
    this.asks,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    lastUpdateId: json["lastUpdateId"],
    bids: json["bids"] == null ? [] : List<List<String>>.from(json["bids"]!.map((x) => List<String>.from(x.map((x) => x)))),
    asks: json["asks"] == null ? [] : List<List<String>>.from(json["asks"]!.map((x) => List<String>.from(x.map((x) => x)))),
  );

}
