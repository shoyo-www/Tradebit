import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) => NotificationResponse.fromJson(json.decode(str));

class NotificationResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  NotificationResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final Notifications? notifications;

  Data({
    this.notifications,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    notifications: json["notifications"] == null ? null : Notifications.fromJson(json["notifications"]),
  );

}

class Notifications {
  final int? currentPage;
  final List<NotificationList>? data;
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

  Notifications({
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

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<NotificationList>.from(json["data"]!.map((x) => NotificationList.fromJson(x))),
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

class NotificationList {
  final int? id;
  final String? content;
  final DateTime? expiredAt;
  final String? type;
  final DateTime? createdAt;
  final String? readStatus;

  NotificationList({
    this.id,
    this.content,
    this.expiredAt,
    this.type,
    this.createdAt,
    this.readStatus,
  });

  factory NotificationList.fromJson(Map<String, dynamic> json) => NotificationList(
    id: json["id"],
    content: json["content"],
    expiredAt: json["expired_at"] == null ? null : DateTime.parse(json["expired_at"]),
    type: json["type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    readStatus: json["read_status"],
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

