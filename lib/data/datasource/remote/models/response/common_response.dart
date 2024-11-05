import 'dart:convert';

CommonResponse commonResponseFromJson(String str) => CommonResponse.fromJson(json.decode(str));


class CommonResponse {
    final String? statusCode;
    final String? statusText;
    final String? message;

    CommonResponse({
        this.statusCode,
        this.statusText,
        this.message,
    });

    factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
        statusCode: json["status_code"],
        statusText: json["status_text"],
        message: json["message"],
    );

}