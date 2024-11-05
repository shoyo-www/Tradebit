import 'dart:convert';

String buyAndSellRequestToJson(BuyAndSellRequest data) => json.encode(data.toJson());

class BuyAndSellRequest {
  final String? orderType;
  final String? type;
  final String? currency;
  final String? withCurrency;
  final double? stopPrice;
  final double? atPrice;
  final double? quantity;
  final double? total;

  BuyAndSellRequest({
    this.orderType,
    this.type,
    this.currency,
    this.withCurrency,
    this.stopPrice,
    this.atPrice,
    this.quantity,
    this.total,
  });

  Map<String, dynamic> toJson() => {
    "order_type": orderType,
    "type": type,
    "currency": currency,
    "with_currency": withCurrency,
    "stop_price": stopPrice,
    "at_price": atPrice,
    "quantity": quantity,
    "total": total,
  };
}
