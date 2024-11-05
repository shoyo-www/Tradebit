import 'dart:convert';

BindEmailResponse bindEmailResponseFromJson(String str) => BindEmailResponse.fromJson(json.decode(str));


class BindEmailResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final List<Datum>? data;

  BindEmailResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory BindEmailResponse.fromJson(Map<String, dynamic> json) => BindEmailResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );
}

class Datum {
  final String? type;
  final String? verifyMask;

  Datum({
    this.type,
    this.verifyMask,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    type: json["type"],
    verifyMask: json["verifyMask"],
  );

}
