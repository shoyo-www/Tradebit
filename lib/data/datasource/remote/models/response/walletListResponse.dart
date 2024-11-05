import 'dart:convert';

WalletListResponse walletListResponseFromJson(String str) => WalletListResponse.fromJson(json.decode(str));


class WalletListResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final List<Datum>? data;
  final String? mainTotal;
  final String? freezedTotal;

  WalletListResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
    this.mainTotal,
    this.freezedTotal,
  });

  factory WalletListResponse.fromJson(Map<String, dynamic> json) => WalletListResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    mainTotal: json["mainTotal"],
    freezedTotal: json["freezedTotal"],
  );
}

class Datum {
  final String? image;
  final int? id;
  final String? name;
  final String? symbol;
  final bool? isMultiple;
  final String? currencyType;
  final String? defaultCNetworkId;
  final bool? activeStatusEnable;
  final bool? depositEnable;
  final String? depositDesc;
  final bool? withdrawEnable;
  final String? withdrawDesc;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CurrencyNetwork>? currencyNetworks;
  final String? quantity;
  final String? fundQuantity;
  final String? stakeQuantity;
  final String? freezedBalance;
  final String? cPrice;
  final String? portfolioShare;
  final String? cBal;
  final String? fundBal;
  final String? stakeBal;
  final String? fcBal;
  final String? fundFreezeBal;
  final String? fundFreezeQ;

  Datum({
    this.image,
    this.id,
    this.name,
    this.symbol,
    this.isMultiple,
    this.currencyType,
    this.defaultCNetworkId,
    this.activeStatusEnable,
    this.depositEnable,
    this.depositDesc,
    this.withdrawEnable,
    this.withdrawDesc,
    this.createdAt,
    this.updatedAt,
    this.currencyNetworks,
    this.quantity,
    this.fundQuantity,
    this.stakeQuantity,
    this.freezedBalance,
    this.cPrice,
    this.portfolioShare,
    this.cBal,
    this.fundBal,
    this.stakeBal,
    this.fcBal,
    this.fundFreezeBal,
    this.fundFreezeQ,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    image: json["image"],
    id: json["id"],
    name: json["name"],
    symbol: json["symbol"],
    isMultiple: json["is_multiple"],
    currencyType: json["currency_type"],
    defaultCNetworkId: json["default_c_network_id"],
    activeStatusEnable: json["active_status_enable"],
    depositEnable: json["deposit_enable"],
    depositDesc: json["deposit_desc"],
    withdrawEnable: json["withdraw_enable"],
    withdrawDesc: json["withdraw_desc"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    currencyNetworks: json["currency_networks"] == null ? [] : List<CurrencyNetwork>.from(json["currency_networks"]!.map((x) => CurrencyNetwork.fromJson(x))),
    quantity: json["quantity"],
    fundQuantity: json["fund_quantity"],
    stakeQuantity: json["stake_quantity"],
    freezedBalance: json["freezed_balance"],
    cPrice: json["c_price"],
    portfolioShare: json["portfolio_share"],
    cBal: json["c_bal"],
    fundBal: json["fund_bal"],
    stakeBal: json["stake_bal"],
    fcBal: json["fc_bal"],
    fundFreezeBal: json["fund_freezed_balance"] == null ? "0.0" : json["fund_freezed_balance"],
    fundFreezeQ: json["fund_freezed_bal"] == null ? "0.0" : json["fund_freezed_bal"],

  );

}

class CurrencyNetwork {
  final int? id;
  final dynamic currencyNetworkCurrencyId;
  final dynamic networkId;
  final String? address;
  final String? tokenType;
  final String? depositMin;
  final bool? depositEnable;
  final String? depositDesc;
  final bool? withdrawEnable;
  final String? withdrawDesc;
  final String? withdrawMin;
  final String? withdrawMax;
  final String? withdrawCommission;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic currencyId;
  final String? walletAddress;

  CurrencyNetwork({
    this.id,
    this.currencyNetworkCurrencyId,
    this.networkId,
    this.address,
    this.tokenType,
    this.depositMin,
    this.depositEnable,
    this.depositDesc,
    this.withdrawEnable,
    this.withdrawDesc,
    this.withdrawMin,
    this.withdrawMax,
    this.withdrawCommission,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.currencyId,
    this.walletAddress,
  });

  factory CurrencyNetwork.fromJson(Map<String, dynamic> json) => CurrencyNetwork(
    id: json["id"],
    currencyNetworkCurrencyId: json["currency_id"],
    networkId: json["network_id"],
    address: json["address"],
    tokenType: json["token_type"],
    depositMin: json["deposit_min"],
    depositEnable: json["deposit_enable"],
    depositDesc: json["deposit_desc"],
    withdrawEnable: json["withdraw_enable"],
    withdrawDesc: json["withdraw_desc"],
    withdrawMin: json["withdraw_min"],
    withdrawMax: json["withdraw_max"],
    withdrawCommission: json["withdraw_commission"],
    type: json["type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    currencyId: json["currencyId"],
    walletAddress: json["wallet_address"],
  );

}


