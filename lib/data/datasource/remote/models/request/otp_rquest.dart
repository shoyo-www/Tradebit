
import 'dart:convert';


String otpRequestToJson(OtpRequest data) => json.encode(data.toJson());

class OtpRequest {
    final String? email;
    final String? emailVcode;
    final String? googleVcode;
    final String? loginType;

    OtpRequest({
        this.email,
        this.emailVcode,
        this.googleVcode,
        this.loginType,
    });

    Map<String, dynamic> toJson() => {
        "email": email,
        "email_vcode": emailVcode,
        "google_vcode": googleVcode,
        "loginType": loginType,
    };
}


String otpRequestMobileToJson(OtpRequest data) => json.encode(data.toJson());

class OtpRequestMobile {
    final String? mobile;
    final String? mobileVcode;
    final String? googleVcode;
    final String? loginType;

    OtpRequestMobile({
        this.mobile,
        this.mobileVcode,
        this.googleVcode,
        this.loginType,
    });

    Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "mobile_vcode": mobileVcode,
        "google_vcode": googleVcode,
        "loginType": loginType,
    };
}