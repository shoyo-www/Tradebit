

import 'dart:convert';

CryptoResponse cryptoResponseFromJson(String str) => CryptoResponse.fromJson(json.decode(str));

String cryptoResponseToJson(CryptoResponse data) => json.encode(data.toJson());

class CryptoResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Crypto? data;
  final List<String>? tickers;
  final List<String>? listedTickers;

  CryptoResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
    this.tickers,
    this.listedTickers,
  });

  factory CryptoResponse.fromJson(Map<String, dynamic> json) => CryptoResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Crypto.fromJson(json["data"]),
    tickers: json["tickers"] == null ? [] : List<String>.from(json["tickers"]!.map((x) => x)),
    listedTickers: json["listed_tickers"] == null ? [] : List<String>.from(json["listed_tickers"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_text": statusText,
    "message": message,
    "data": data?.toJson(),
    "tickers": tickers == null ? [] : List<dynamic>.from(tickers!.map((x) => x)),
    "listed_tickers": listedTickers == null ? [] : List<dynamic>.from(listedTickers!.map((x) => x)),
  };
}

class Crypto {
  final List<Btc>? usdt;
  final List<Btc>? eth;
  final List<Btc>? btc;
  final List<Btc>? trx;
  final List<Btc>? tbc;

  Crypto({
    this.usdt,
    this.eth,
    this.btc,
    this.trx,
    this.tbc,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) => Crypto(
    usdt: json["USDT"] == null ? [] : List<Btc>.from(json["USDT"]!.map((x) => Btc.fromJson(x))),
    eth: json["ETH"] == null ? [] : List<Btc>.from(json["ETH"]!.map((x) => Btc.fromJson(x))),
    btc: json["BTC"] == null ? [] : List<Btc>.from(json["BTC"]!.map((x) => Btc.fromJson(x))),
    trx: json["TRX"] == null ? [] : List<Btc>.from(json["TRX"]!.map((x) => Btc.fromJson(x))),
    tbc: json["TBC"] == null ? [] : List<Btc>.from(json["TBC"]!.map((x) => Btc.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "USDT": usdt == null ? [] : List<dynamic>.from(usdt!.map((x) => x.toJson())),
    "ETH": eth == null ? [] : List<dynamic>.from(eth!.map((x) => x.toJson())),
    "BTC": btc == null ? [] : List<dynamic>.from(btc!.map((x) => x.toJson())),
    "TRX": trx == null ? [] : List<dynamic>.from(trx!.map((x) => x.toJson())),
    "TBC": tbc == null ? [] : List<dynamic>.from(tbc!.map((x) => x.toJson())),
  };
}

class Btc {
  final String? image;
   String? symbol;
  final String? flag;
  final bool? listed;
  final int? id;
  final String? name;
  final String? currency;
  final String? pairWith;
  final String? decimalCurrency;
  final String? decimalPair;
  final String? buyMinDesc;
  final String? buyMaxDesc;
  final String? buyDesc;
  final String? sellMinDesc;
  final String? sellMaxDesc;
  final String? sellDesc;
  final DateTime? createdAt;
  final DateTime? updatedAt;
   String? price;
   String? change;
  final dynamic volume;
  final String? high;
  final String? low;
  final String? startPrice;
  final String? currentPrice;
  final String? changePrice;
  final dynamic quantity;

  Btc({
    this.image,
    this.symbol,
    this.flag,
    this.listed,
    this.id,
    this.name,
    this.currency,
    this.pairWith,
    this.decimalCurrency,
    this.decimalPair,
    this.buyMinDesc,
    this.buyMaxDesc,
    this.buyDesc,
    this.sellMinDesc,
    this.sellMaxDesc,
    this.sellDesc,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.change,
    this.volume,
    this.high,
    this.low,
    this.startPrice,
    this.currentPrice,
    this.changePrice,
    this.quantity,
  });

  factory Btc.fromJson(Map<String, dynamic> json) => Btc(
    image: json["image"],
    symbol: json["symbol"],
    flag: json["flag"],
    listed: json["listed"],
    id: json["id"],
    name: json["name"],
    currency: json["currency"],
    pairWith: json["pair_with"],
    decimalCurrency: json["decimal_currency"],
    decimalPair: json["decimal_pair"],
    buyMinDesc: json["buy_min_desc"],
    buyMaxDesc: json["buy_max_desc"],
    buyDesc: json["buy_desc"],
    sellMinDesc: json["sell_min_desc"],
    sellMaxDesc: json["sell_max_desc"],
    sellDesc: json["sell_desc"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    price: json["price"],
    change: json["change"],
    volume: json["volume"],
    high: json["high"],
    low: json["low"],
    startPrice: json["start_price"],
    currentPrice: json["current_price"],
    changePrice: json["change_price"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "symbol": symbol,
    "flag": flag,
    "listed": listed,
    "id": id,
    "name": name,
    "currency": currency,
    "pair_with": pairWith,
    "decimal_currency": decimalCurrency,
    "decimal_pair": decimalPair,
    "buy_min_desc": buyMinDesc,
    "buy_max_desc": buyMaxDesc,
    "buy_desc": buyDesc,
    "sell_min_desc": sellMinDesc,
    "sell_max_desc": sellMaxDesc,
    "sell_desc": sellDesc,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "price": price,
    "change": change,
    "volume": volume,
    "high": high,
    "low": low,
    "start_price": startPrice,
    "current_price": currentPrice,
    "change_price": changePrice,
    "quantity": quantity,
  };
}


