import 'dart:convert';

ActivityResponse activityResponseFromJson(String str) => ActivityResponse.fromJson(json.decode(str));

class ActivityResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  ActivityResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) => ActivityResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final int? currentPage;
  final List<ActivityData>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final String? nextPageUrl;
  final String? path;
  final String? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<ActivityData>.from(json["data"]!.map((x) => ActivityData.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );
}

class ActivityData {
  final int? id;
  final String? userId;
  final String? type;
  final String? ip;
  final String? message;
  final dynamic ipv4;
  final dynamic city;
  final dynamic countryCode;
  final dynamic countryName;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic postal;
  final dynamic state;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ActivityData({
    this.id,
    this.userId,
    this.type,
    this.ip,
    this.message,
    this.ipv4,
    this.city,
    this.countryCode,
    this.countryName,
    this.latitude,
    this.longitude,
    this.postal,
    this.state,
    this.createdAt,
    this.updatedAt,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) => ActivityData(
    id: json["id"],
    userId: json["user_id"],
    type: json["type"],
    ip: json["ip"],
    message: json["message"],
    ipv4: json["ipv4"],
    city: json["city"],
    countryCode: json["country_code"],
    countryName: json["country_name"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    postal: json["postal"],
    state: json["state"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

}
