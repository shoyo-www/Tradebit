import 'dart:convert';

String sendTokenRequestToJson(SendTokenRequest data) => json.encode(data.toJson());

class SendTokenRequest {
  String fromWallet;
  String toWallet;
  String amount;
  String currency;

  SendTokenRequest({
    required this.fromWallet,
    required this.toWallet,
    required this.amount,
    required this.currency,
  });


  Map<String, dynamic> toJson() => {
    "from_wallet": fromWallet,
    "to_wallet": toWallet,
    "amount": amount,
    "currency": currency,
  };
}
