import 'dart:convert';

String transferRequestToJson(TransferRequest data) => json.encode(data.toJson());

class TransferRequest {
  final String? user;
  final String? amount;
  final String? currency;
  final String? walletType;
  final String? type;
  final String? emailVcode;
  final String? mobileVcode;
  final String? googleVcode;

  TransferRequest({
    this.user,
    this.amount,
    this.currency,
    this.walletType,
    this.type,
    this.emailVcode,
    this.mobileVcode,
    this.googleVcode,
  });


  Map<String, dynamic> toJson() => {
    "user": user,
    "amount": amount,
    "currency": currency,
    "wallet_type": walletType,
    "type": type,
    "email_vcode": emailVcode,
    "mobile_vcode": mobileVcode,
    "google_vcode": googleVcode,
  };
}
