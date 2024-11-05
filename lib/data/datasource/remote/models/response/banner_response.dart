import 'dart:convert';

BannerResponse bannerResponseFromJson(String str) => BannerResponse.fromJson(json.decode(str));

String bannerResponseToJson(BannerResponse data) => json.encode(data.toJson());

class BannerResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final List<Banners>? data;

  BannerResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) => BannerResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Banners>.from(json["data"]!.map((x) => Banners.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_text": statusText,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Banners {
  final int? id;
  final String? image;
  final String? type;
  final int? orderIndex;
  final String? link;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Banners({
    this.id,
    this.image,
    this.type,
    this.orderIndex,
    this.link,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
    id: json["id"],
    image: json["image"],
    type: json["type"],
    orderIndex: json["orderIndex"],
    link: json["link"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "type": type,
    "orderIndex": orderIndex,
    "link": link,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
