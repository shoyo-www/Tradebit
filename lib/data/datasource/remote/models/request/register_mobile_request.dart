import 'dart:convert';


String registerMobileOtpRequestToJson(RegisterMobileOtpRequest data) => json.encode(data.toJson());

class RegisterMobileOtpRequest {
    final String? mobile;
    final String? mobile_vcode;
    final String? token;

    RegisterMobileOtpRequest({
        this.mobile,
        this.mobile_vcode,
        this.token,
    });

    Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "mobile_vcode": mobile_vcode,
        "token": token,
    };
}