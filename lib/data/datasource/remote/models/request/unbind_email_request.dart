import 'dart:convert';


String unBindEmailRequestToJson(UnBindEmailRequest data) => json.encode(data.toJson());

class UnBindEmailRequest {
  final String? emailVcode;
  final String? mobileVcode;
  final String? googleVcode;

  UnBindEmailRequest({
    this.emailVcode,
    this.mobileVcode,
    this.googleVcode
  });

  Map<String, dynamic> toJson() => {
    "email_vcode": emailVcode,
    "mobile_vcode": mobileVcode,
    "google_vcode" : googleVcode
  };
}
