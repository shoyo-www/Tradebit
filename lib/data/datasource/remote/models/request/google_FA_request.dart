
import 'dart:convert';

String googleRequestToJson(GoogleRequest data) => json.encode(data.toJson());

class GoogleRequest {
  final String? totp;
  final String? secret;

  GoogleRequest({
    this.totp,
    this.secret,
  });

  Map<String, dynamic> toJson() => {
    "totp": totp,
    "secret": secret,
  };
}
