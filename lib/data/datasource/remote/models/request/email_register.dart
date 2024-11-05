
import 'dart:convert';


String registerEmailRequestToJson(RegisterEmailRequest data) => json.encode(data.toJson());

class RegisterEmailRequest {
    final String? email;
    final String? password;
    final String? referral;
    final bool? terms;

    RegisterEmailRequest({
        this.email,
        this.password,
        this.referral,
        this.terms,
    });


    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "referral": referral,
        "terms": terms,
    };
}
