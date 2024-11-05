import 'dart:convert';


String registerEmailRequestToJson(WithdrawRequest data) => json.encode(data.toJson());

class WithdrawRequest {
  final String? tokenType;
  final String? amount;
  final String? toAddress;
  final String? currency;

  WithdrawRequest({
    this.tokenType,
    this.amount,
    this.toAddress,
    this.currency,
  });


  Map<String, dynamic> toJson() => {
    "token_type": tokenType,
    "amount": amount,
    "toAddress": toAddress,
    "currency": currency,
  };
}