import 'dart:convert';

ReferIncomeResponse referIncomeResponseFromJson(String str) => ReferIncomeResponse.fromJson(json.decode(str));

String referIncomeResponseToJson(ReferIncomeResponse data) => json.encode(data.toJson());

class ReferIncomeResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  ReferIncomeResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory ReferIncomeResponse.fromJson(Map<String, dynamic> json) => ReferIncomeResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_text": statusText,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final int? currentPage;
  final List<ReferData>? data;
  final int? from;
  final int? to;
  final int? lastPage;
  final int? perPage;
  final int? total;

  Data({
    this.currentPage,
    this.data,
    this.from,
    this.to,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<ReferData>.from(json["data"]!.map((x) => ReferData.fromJson(x))),
    from: json["from"],
    to: json["to"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "from": from,
    "to": to,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
  };
}

class ReferData {
  final int? id;
  final dynamic name;
  final String? username;
  final String? email;
  final DateTime? emailVerifiedAt;
  final dynamic mobile;
  final dynamic mobileVerifiedAt;
  final String? profileStatus;
  final String? role;
  final String? profileImage;
  final bool? userVerify;
  final int? emailOtp;
  final int? smsOtp;
  final int? google2Fa;
  final dynamic google2FaSecret;
  final dynamic location;
  final dynamic countryCode;
  final dynamic countryCallingCode;
  final bool? otpStatus;
  final bool? feeByLbm;
  final bool? tradeStatus;
  final bool? status;
  final String? referralCode;
  final String? referralBy;
  final String? noCommission;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReferData({
    this.id,
    this.name,
    this.username,
    this.email,
    this.emailVerifiedAt,
    this.mobile,
    this.mobileVerifiedAt,
    this.profileStatus,
    this.role,
    this.profileImage,
    this.userVerify,
    this.emailOtp,
    this.smsOtp,
    this.google2Fa,
    this.google2FaSecret,
    this.location,
    this.countryCode,
    this.countryCallingCode,
    this.otpStatus,
    this.feeByLbm,
    this.tradeStatus,
    this.status,
    this.referralCode,
    this.referralBy,
    this.noCommission,
    this.createdAt,
    this.updatedAt,
  });

  factory ReferData.fromJson(Map<String, dynamic> json) => ReferData(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
    mobile: json["mobile"],
    mobileVerifiedAt: json["mobile_verified_at"],
    profileStatus: json["profile_status"],
    role: json["role"],
    profileImage: json["profile_image"],
    userVerify: json["user_verify"],
    emailOtp: json["email_otp"],
    smsOtp: json["sms_otp"],
    google2Fa: json["google2fa"],
    google2FaSecret: json["google2fa_secret"],
    location: json["location"],
    countryCode: json["country_code"],
    countryCallingCode: json["country_calling_code"],
    otpStatus: json["otp_status"],
    feeByLbm: json["fee_by_lbm"],
    tradeStatus: json["trade_status"],
    status: json["status"],
    referralCode: json["referral_code"],
    referralBy: json["referral_by"],
    noCommission: json["no_commission"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "email": email,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "mobile": mobile,
    "mobile_verified_at": mobileVerifiedAt,
    "profile_status": profileStatus,
    "role": role,
    "profile_image": profileImage,
    "user_verify": userVerify,
    "email_otp": emailOtp,
    "sms_otp": smsOtp,
    "google2fa": google2Fa,
    "google2fa_secret": google2FaSecret,
    "location": location,
    "country_code": countryCode,
    "country_calling_code": countryCallingCode,
    "otp_status": otpStatus,
    "fee_by_lbm": feeByLbm,
    "trade_status": tradeStatus,
    "status": status,
    "referral_code": referralCode,
    "referral_by": referralBy,
    "no_commission": noCommission,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
