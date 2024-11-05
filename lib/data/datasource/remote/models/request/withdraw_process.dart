import 'dart:convert';

String walletProcessRequestToJson(WalletProcessRequest data) => json.encode(data.toJson());

class WalletProcessRequest {
  final String tokenType;
  final String amount;
  final String toAddress;
  final String currency;

  WalletProcessRequest({
    required this.tokenType,
    required this.amount,
    required this.toAddress,
    required this.currency,
  });


  Map<String, dynamic> toJson() => {
    "token_type": tokenType,
    "amount": amount,
    "toAddress": toAddress,
    "currency": currency,
  };
}
