

import 'dart:convert';

ReferralsResponse referralsResponseFromJson(String str) => ReferralsResponse.fromJson(json.decode(str));

String referralsResponseToJson(ReferralsResponse data) => json.encode(data.toJson());

class ReferralsResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final List<ReferralData>? data;

  ReferralsResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory ReferralsResponse.fromJson(Map<String, dynamic> json) => ReferralsResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? [] : List<ReferralData>.from(json["data"]!.map((x) => ReferralData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_text": statusText,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ReferralData {
  final int? id;
  final String? name;
  final String? username;
  final String? email;
  final DateTime? emailVerifiedAt;
  final dynamic mobile;
  final dynamic countryCode;
  final dynamic countryCallingCode;
  final dynamic mobileVerifiedAt;
  final String? role;
  final String? profileImage;
  final int? userVerify;
  final int? otpStatus;
  final int? the2Fa;
  final int? emailOtp;
  final int? smsOtp;
  final int? google2Fa;
  final dynamic google2FaSecret;
  final dynamic emailSetup;
  final dynamic smsSetup;
  final int? feeByLbm;
  final int? tradeStatus;
  final int? status;
  final String? referralCode;
  final String? referralBy;
  final String? noCommission;
  final String? profileStatus;
  final dynamic location;
  final dynamic facebookId;
  final dynamic googleId;
  final String? accountType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userKycStatus;
  final String? userKycStatusMessage;
  final bool? isReward;
  final dynamic rewards;

  ReferralData({
    this.id,
    this.name,
    this.username,
    this.email,
    this.emailVerifiedAt,
    this.mobile,
    this.countryCode,
    this.countryCallingCode,
    this.mobileVerifiedAt,
    this.role,
    this.profileImage,
    this.userVerify,
    this.otpStatus,
    this.the2Fa,
    this.emailOtp,
    this.smsOtp,
    this.google2Fa,
    this.google2FaSecret,
    this.emailSetup,
    this.smsSetup,
    this.feeByLbm,
    this.tradeStatus,
    this.status,
    this.referralCode,
    this.referralBy,
    this.noCommission,
    this.profileStatus,
    this.location,
    this.facebookId,
    this.googleId,
    this.accountType,
    this.createdAt,
    this.updatedAt,
    this.userKycStatus,
    this.userKycStatusMessage,
    this.isReward,
    this.rewards,
  });

  factory ReferralData.fromJson(Map<String, dynamic> json) => ReferralData(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
    mobile: json["mobile"],
    countryCode: json["country_code"],
    countryCallingCode: json["country_calling_code"],
    mobileVerifiedAt: json["mobile_verified_at"],
    role: json["role"],
    profileImage: json["profile_image"],
    userVerify: json["user_verify"],
    otpStatus: json["otp_status"],
    the2Fa: json["_2fa"],
    emailOtp: json["email_otp"],
    smsOtp: json["sms_otp"],
    google2Fa: json["google2fa"],
    google2FaSecret: json["google2fa_secret"],
    emailSetup: json["email_setup"],
    smsSetup: json["sms_setup"],
    feeByLbm: json["fee_by_lbm"],
    tradeStatus: json["trade_status"],
    status: json["status"],
    referralCode: json["referral_code"],
    referralBy: json["referral_by"],
    noCommission: json["no_commission"],
    profileStatus: json["profile_status"],
    location: json["location"],
    facebookId: json["facebook_id"],
    googleId: json["google_id"],
    accountType: json["account_type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    userKycStatus: json["user_kyc_status"],
    userKycStatusMessage: json["user_kyc_status_message"],
    isReward: json["is_reward"],
    rewards: json["rewards"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "email": email,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "mobile": mobile,
    "country_code": countryCode,
    "country_calling_code": countryCallingCode,
    "mobile_verified_at": mobileVerifiedAt,
    "role": role,
    "profile_image": profileImage,
    "user_verify": userVerify,
    "otp_status": otpStatus,
    "_2fa": the2Fa,
    "email_otp": emailOtp,
    "sms_otp": smsOtp,
    "google2fa": google2Fa,
    "google2fa_secret": google2FaSecret,
    "email_setup": emailSetup,
    "sms_setup": smsSetup,
    "fee_by_lbm": feeByLbm,
    "trade_status": tradeStatus,
    "status": status,
    "referral_code": referralCode,
    "referral_by": referralBy,
    "no_commission": noCommission,
    "profile_status": profileStatus,
    "location": location,
    "facebook_id": facebookId,
    "google_id": googleId,
    "account_type": accountType,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user_kyc_status": userKycStatus,
    "user_kyc_status_message": userKycStatusMessage,
    "is_reward": isReward,
    "rewards": rewards,
  };
}
