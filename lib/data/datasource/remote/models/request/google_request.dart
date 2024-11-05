import 'dart:convert';

String googleLoginRequestToJson(GoogleLoginrequest  data) => json.encode(data.toJson());

class GoogleLoginrequest  {
  String email;
  String emailVcode;
  String mobile_vcode;
  String googleVcode;
  String loginType;
  String mobile;

  GoogleLoginrequest ({
    required this.email,
    required this.emailVcode,
    required this.googleVcode,
    required this.loginType,
    required this.mobile_vcode,
    required this.mobile
  });


  Map<String, dynamic> toJson() => {
    "email": email,
    "mobile" : mobile,
    "email_vcode": emailVcode,
    "google_vcode": googleVcode,
    "loginType": loginType,
    "mobile_vcode": mobile_vcode,
  };
}
