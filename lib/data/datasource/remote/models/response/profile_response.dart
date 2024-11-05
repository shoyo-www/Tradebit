// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) => ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) => json.encode(data.toJson());

class ProfileResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final ProfileData? data;

  ProfileResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_text": statusText,
    "message": message,
    "data": data?.toJson(),
  };
}

class ProfileData {
  final String? name;
  final String? username;
  final dynamic profileImage;
  final String? email;
  final String? mobile;
  final String? countryCallingCode;
  final DateTime? createdAt;
  final DateTime? emailVerifiedAt;
  final int? emailOtp;
  final int? smsOtp;
  final int? google2Fa;
  final String? countryCode;
  final DateTime? mobileVerifiedAt;
  final bool? status;
  final String? profileStatus;
  final String? location;
  final String? userKycStatus;

  ProfileData({
    this.name,
    this.username,
    this.profileImage,
    this.email,
    this.mobile,
    this.countryCallingCode,
    this.createdAt,
    this.emailVerifiedAt,
    this.emailOtp,
    this.smsOtp,
    this.google2Fa,
    this.countryCode,
    this.mobileVerifiedAt,
    this.status,
    this.profileStatus,
    this.location,
    this.userKycStatus,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    name: json["name"],
    username: json["username"],
    profileImage: json["profile_image"],
    email: json["email"],
    mobile: json["mobile"],
    countryCallingCode: json["country_calling_code"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
    emailOtp: json["email_otp"],
    smsOtp: json["sms_otp"],
    google2Fa: json["google2fa"],
    countryCode: json["country_code"],
    mobileVerifiedAt: json["mobile_verified_at"] == null ? null : DateTime.parse(json["mobile_verified_at"]),
    status: json["status"],
    profileStatus: json["profile_status"],
    location: json["location"],
    userKycStatus: json["user_kyc_status"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "username": username,
    "profile_image": profileImage,
    "email": email,
    "mobile": mobile,
    "country_calling_code": countryCallingCode,
    "created_at": createdAt?.toIso8601String(),
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "email_otp": emailOtp,
    "sms_otp": smsOtp,
    "google2fa": google2Fa,
    "country_code": countryCode,
    "mobile_verified_at": mobileVerifiedAt?.toIso8601String(),
    "status": status,
    "profile_status": profileStatus,
    "location": location,
    "user_kyc_status": userKycStatus,
  };
}
