import 'dart:convert';

SecurityResponse securityResponseFromJson(String str) => SecurityResponse.fromJson(json.decode(str));

class SecurityResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  SecurityResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory SecurityResponse.fromJson(Map<String, dynamic> json) => SecurityResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final int? emailOtp;
  final int? smsOtp;
  final int? google2Fa;
  final String? userKycStatus;
  final String? userKycStatusMessage;
  final bool? isReward;
  final dynamic rewards;

  Data({
    this.emailOtp,
    this.smsOtp,
    this.google2Fa,
    this.userKycStatus,
    this.userKycStatusMessage,
    this.isReward,
    this.rewards,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    emailOtp: json["email_otp"],
    smsOtp: json["sms_otp"],
    google2Fa: json["google2fa"],
    userKycStatus: json["user_kyc_status"],
    userKycStatusMessage: json["user_kyc_status_message"],
    isReward: json["is_reward"],
    rewards: json["rewards"],
  );

}
