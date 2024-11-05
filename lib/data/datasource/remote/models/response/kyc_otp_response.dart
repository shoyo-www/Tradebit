import 'dart:convert';

KycOtpResponse kycOtpResponseFromJson(String str) => KycOtpResponse.fromJson(json.decode(str));


class KycOtpResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  KycOtpResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory KycOtpResponse.fromJson(Map<String, dynamic> json) => KycOtpResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final String? refId;
  final String? accessToken;

  Data({
    this.refId,
    this.accessToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    refId: json["ref_id"],
    accessToken: json["access_token"],
  );

}
