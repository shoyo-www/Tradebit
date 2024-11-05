import 'dart:convert';


String emailOtpRequestToJson(RegisterEmailOtpRequest data) => json.encode(data.toJson());

class RegisterEmailOtpRequest {
  final String? email;
  final String? emailVcode;
  final String? token;

  RegisterEmailOtpRequest({
    this.email,
    this.emailVcode,
    this.token,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "email_vcode": emailVcode,
    "token": token,
  };
}