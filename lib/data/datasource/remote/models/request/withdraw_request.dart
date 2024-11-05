import 'dart:convert';

String verifyWithdrawToJson(VerifyWithdraw data) => json.encode(data.toJson());

class VerifyWithdraw {
  final String emailVcode;
  final String mobileVcode;
  final String googleVcode;
  final String tokenType;
  final String amount;
  final String toAddress;
  final String currency;

  VerifyWithdraw({
    required this.emailVcode,
    required this.mobileVcode,
    required this.googleVcode,
    required this.tokenType,
    required this.amount,
    required this.toAddress,
    required this.currency,
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
