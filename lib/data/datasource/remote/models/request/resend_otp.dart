import 'dart:convert';


String resendOtpRequestToJson(ResendOtpRequest data) => json.encode(data.toJson());

class ResendOtpRequest {
  final String? type;
  final String? email;
  final String? mobile;

  ResendOtpRequest({
    this.type,
    this.email,
    this.mobile
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "email": email,
    "mobile": mobile,
  };
}
