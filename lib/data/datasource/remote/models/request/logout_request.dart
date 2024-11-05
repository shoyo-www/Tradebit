import 'dart:convert';

String logoutFromJson(LogoutRequest data) => json.encode(data.toJson());

class LogoutRequest {
  final String email;

  LogoutRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
  };
}
