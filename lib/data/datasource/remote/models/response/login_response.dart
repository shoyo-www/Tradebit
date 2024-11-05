import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));


class LoginResponse {
    final String? statusCode;
    final String? statusText;
    final String? message;
    final Data? data;

    LoginResponse({
        this.statusCode,
        this.statusText,
        this.message,
        this.data,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        statusCode: json["status_code"],
        statusText: json["status_text"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

}

class Data {
    final String? email;
    final String? otpType;
    final String? sendType;
    final DateTime? expiredAt;
    final bool? google2Fa;

    Data({
        this.email,
        this.otpType,
        this.sendType,
        this.expiredAt,
        this.google2Fa,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        otpType: json["otp_type"],
        sendType: json["send_type"],
        expiredAt: json["expired_at"] == null ? null : DateTime.parse(json["expired_at"]),
        google2Fa: json["google2fa"],
    );

}