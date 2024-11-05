import 'dart:convert';

String redeemRequestToJson(RedeemRequest data) => json.encode(data.toJson());

class RedeemRequest {
  final String amount;
  final String currency;

  RedeemRequest({
    required this.amount,
    required this.currency,
  });



  Map<String, dynamic> toJson() => {
    "amount": amount,
    "currency": currency,
  };
}
