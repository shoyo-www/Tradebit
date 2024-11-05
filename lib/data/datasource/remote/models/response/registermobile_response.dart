import 'dart:convert';

RegisterMobileResponse registerMobileResponseFromJson(String str) => RegisterMobileResponse.fromJson(json.decode(str));

String registerMobileResponseToJson(RegisterMobileResponse data) => json.encode(data.toJson());

class RegisterMobileResponse {
    final String? statusCode;
    final String? statusText;
    final String? message;
    final Data? data;

    RegisterMobileResponse({
        this.statusCode,
        this.statusText,
        this.message,
        this.data,
    });

    factory RegisterMobileResponse.fromJson(Map<String, dynamic> json) => RegisterMobileResponse(
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
    final dynamic email;
    final int? mobile;
    final String? token;
    final DateTime? expiredAt;

    Data({
        this.email,
        this.mobile,
        this.token,
        this.expiredAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        mobile: json["mobile"],
        token: json["token"],
        expiredAt: json["expired_at"] == null ? null : DateTime.parse(json["expired_at"]),
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "mobile": mobile,
        "token": token,
        "expired_at": expiredAt?.toIso8601String(),
    };
}


