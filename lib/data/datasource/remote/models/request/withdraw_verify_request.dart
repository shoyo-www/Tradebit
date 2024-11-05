import 'dart:convert';

String verifyWithdrawRequestToJson(VerifyWithdrawRequest data) => json.encode(data.toJson());

class VerifyWithdrawRequest {
  final String? emailVcode;
  final String? mobileVcode;
  final String? googleVcode;
  final String? tokenType;
  final String? amount;
  final String? toAddress;
  final String? currency;

  VerifyWithdrawRequest({
    this.emailVcode,
    this.mobileVcode,
    this.googleVcode,
    this.tokenType,
    this.amount,
    this.toAddress,
    this.currency,
  });


  Map<String, dynamic> toJson() => {
    "email_vcode": emailVcode,
    "mobile_vcode": mobileVcode,
    "google_vcode": googleVcode,
    "token_type": tokenType,
    "amount": amount,
    "toAddress": toAddress,
    "currency": currency,
  };
}
