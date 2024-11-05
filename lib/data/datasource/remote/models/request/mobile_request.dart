
import 'dart:convert';

MobileRequest mobileRequestFromJson(String str) => MobileRequest.fromJson(json.decode(str));

String mobileRequestToJson(MobileRequest data) => json.encode(data.toJson());

class MobileRequest {
    final String? mobile;
    final String? loginType;
    final String? password;
    final String? captchaResponse;

    MobileRequest({
        this.mobile,
        this.loginType,
        this.password,
        this.captchaResponse,
    });

    factory MobileRequest.fromJson(Map<String, dynamic> json) => MobileRequest(
        mobile: json["mobile"],
        loginType: json["loginType"],
        password: json["password"],
        captchaResponse: json["captcha_response"],
    );

    Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "loginType": loginType,
        "password": password,
        "captcha_response": captchaResponse,
    };
}
