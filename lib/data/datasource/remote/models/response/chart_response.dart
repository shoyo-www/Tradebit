import 'dart:convert';

ChartResponse chartResponseFromJson(String str) => ChartResponse.fromJson(json.decode(str));

String chartResponseToJson(ChartResponse data) => json.encode(data.toJson());

class ChartResponse {
  String? statusCode;
  String? statusText;
  String? message;
  List<Chart>? data;

  ChartResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory ChartResponse.fromJson(Map<String, dynamic> json) => ChartResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Chart>.from(json["data"]!.map((x) => Chart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_text": statusText,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Chart {
  int? startTime;
  int? endTime;
  Ohlc? ohlc;

  Chart({
    this.startTime,
    this.endTime,
    this.ohlc,
  });

  factory Chart.fromJson(Map<String, dynamic> json) => Chart(
    startTime: json["start_time"],
    endTime: json["end_time"],
    ohlc: json["ohlc"] == null ? null : Ohlc.fromJson(json["ohlc"]),
  );

  Map<String, dynamic> toJson() => {
    "start_time": startTime,
    "end_time": endTime,
    "ohlc": ohlc?.toJson(),
  };
}

class Ohlc {
  B? ohlcB;
  int? b;
  String? o;
  S? s;
  String? h;
  String? l;
  String? c;
  double? v;
  dynamic q;

  Ohlc({
    this.ohlcB,
    this.b,
    this.o,
    this.s,
    this.h,
    this.l,
    this.c,
    this.v,
    this.q,
  });

  factory Ohlc.fromJson(Map<String, dynamic> json) => Ohlc(
    ohlcB: bValues.map[json["b"]]!,
    b: json["B"],
    o: json["o"],
    s: sValues.map[json["s"]]!,
    h: json["h"],
    l: json["l"],
    c: json["c"],
    v: json["v"]?.toDouble(),
    q: json["q"],
  );

  Map<String, dynamic> toJson() => {
    "b": bValues.reverse[ohlcB],
    "B": b,
    "o": o,
    "s": sValues.reverse[s],
    "h": h,
    "l": l,
    "c": c,
    "v": v,
    "q": q,
  };
}

enum B {
  TRADEBIT
}

final bValues = EnumValues({
  "tradebit": B.TRADEBIT
});

enum S {
  MCOINUSDT
}

final sValues = EnumValues({
  "MCOINUSDT": S.MCOINUSDT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
