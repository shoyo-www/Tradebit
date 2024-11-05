import 'dart:convert';

String walletCreateRequestToJson(WalletCreateRequest data) => json.encode(data.toJson());

class WalletCreateRequest {
  final String currencyId;
  final String networkId;
  final String tokenType;

  WalletCreateRequest({
    required this.currencyId,
    required this.networkId,
    required this.tokenType,
  });

  Map<String, dynamic> toJson() => {
    "currency_id": currencyId,
    "network_id": networkId,
    "token_type": tokenType,
  };
}
