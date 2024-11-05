import 'dart:convert';

BindEmailResponse bindEmailResponseFromJson(String str) => BindEmailResponse.fromJson(json.decode(str));

String bindEmailResponseToJson(BindEmailResponse data) => json.encode(data.toJson());

class BindEmailResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

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
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_text": statusText,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final String? email;
  final dynamic mobile;
  final String? otpType;
  final String? sendType;
  final DateTime? expiredAt;

  Data({
    this.email,
    this.mobile,
    this.otpType,
    this.sendType,
    this.expiredAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    email: json["email"],
    mobile: json["mobile"],
    otpType: json["otp_type"],
    sendType: json["send_type"],
    expiredAt: json["expired_at"] == null ? null : DateTime.parse(json["expired_at"]),
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "mobile": mobile,
    "otp_type": otpType,
    "send_type": sendType,
    "expired_at": expiredAt?.toIso8601String(),
  };
}
