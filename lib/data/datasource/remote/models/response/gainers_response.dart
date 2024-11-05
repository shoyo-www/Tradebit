import 'dart:convert';

GainerResponse gainerResponseFromJson(String str) => GainerResponse.fromJson(json.decode(str));

class GainerResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  GainerResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory GainerResponse.fromJson(Map<String, dynamic> json) => GainerResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final List<CoreDatum>? coreData;
  final List<CoreDatum>? losers;
  final List<CoreDatum>? gainers;
  final List<String>? tickers;

  Data({
    this.coreData,
    this.losers,
    this.gainers,
    this.tickers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    coreData: json["core_data"] == null ? [] : List<CoreDatum>.from(json["core_data"]!.map((x) => CoreDatum.fromJson(x))),
    losers: json["losers"] == null ? [] : List<CoreDatum>.from(json["losers"]!.map((x) => CoreDatum.fromJson(x))),
    gainers: json["gainers"] == null ? [] : List<CoreDatum>.from(json["gainers"]!.map((x) => CoreDatum.fromJson(x))),
    tickers: json["tickers"] == null ? [] : List<String>.from(json["tickers"]!.map((x) => x)),
  );

}

class CoreDatum {
  final String? symbol;
  String? priceChange;
  String? priceChangePercent;
  final String? weightedAvgPrice;
  final String? prevClosePrice;
  final String? lastPrice;
  final String? lastQty;
  final String? bidPrice;
  final String? bidQty;
  final String? askPrice;
  final String? image;
  final String? askQty;
  final String? openPrice;
  String? highPrice;
  final String? lowPrice;
  final String? volume;
  final String? quoteVolume;
  final int? openTime;
  final int? closeTime;
  final int? firstId;
  final int? lastId;
  final int? count;
  final String? name;

  CoreDatum({
    this.symbol,
    this.priceChange,
    this.priceChangePercent,
    this.weightedAvgPrice,
    this.prevClosePrice,
    this.lastPrice,
    this.lastQty,
    this.bidPrice,
    this.bidQty,
    this.askPrice,
    this.image,
    this.askQty,
    this.openPrice,
    this.highPrice,
    this.lowPrice,
    this.volume,
    this.quoteVolume,
    this.openTime,
    this.closeTime,
    this.firstId,
    this.lastId,
    this.count,
    this.name
  });

  factory CoreDatum.fromJson(Map<String, dynamic> json) => CoreDatum(
    symbol: json["symbol"],
    priceChange: json["priceChange"],
    priceChangePercent: json["priceChangePercent"],
    weightedAvgPrice: json["weightedAvgPrice"],
    prevClosePrice: json["prevClosePrice"],
    lastPrice: json["lastPrice"],
    lastQty: json["lastQty"],
    bidPrice: json["bidPrice"],
    bidQty: json["bidQty"],
    askPrice: json["askPrice"],
    askQty: json["askQty"],
    openPrice: json["openPrice"],
    highPrice: json["highPrice"],
    lowPrice: json["lowPrice"],
    volume: json["volume"],
    image: json["image"],
    quoteVolume: json["quoteVolume"],
    openTime: json["openTime"],
    closeTime: json["closeTime"],
    firstId: json["firstId"],
    lastId: json["lastId"],
    count: json["count"],
    name:  json["name"]
  );

}
