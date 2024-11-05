import 'dart:convert';

GoogleFa googleFaFromJson(String str) => GoogleFa.fromJson(json.decode(str));

class GoogleFa {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  GoogleFa({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory GoogleFa.fromJson(Map<String, dynamic> json) => GoogleFa(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final String? secret;
  final String? imageUrl;
  final int? google2Fa;

  Data({
    this.secret,
    this.imageUrl,
    this.google2Fa,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    secret: json["secret"],
    imageUrl: json["image_url"],
    google2Fa: json["google2fa"],
  );

}
