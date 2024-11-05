import 'dart:convert';

String newDataToJson(ForgotByEmailRequest data) => json.encode(data.toJson());

class ForgotByEmailRequest {
  final String email;

  ForgotByEmailRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}
