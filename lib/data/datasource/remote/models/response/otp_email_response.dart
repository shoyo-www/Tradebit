

import 'dart:convert';

OtpEmailResponse otpEmailResponseFromJson(String str) => OtpEmailResponse.fromJson(json.decode(str));


class OtpEmailResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  OtpEmailResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory OtpEmailResponse.fromJson(Map<String, dynamic> json) => OtpEmailResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final String? token;
  final User? user;

  Data({
    this.token,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

}

class User {
  final int? id;
  final String? email;
  final dynamic mobile;
  final String? username;
  final String? profileImage;
  final String? profileStatus;
  final int? status;
  final String? referralCode;
  final String? userKycStatus;
  final String? userKycStatusMessage;
  final bool? isReward;
  final dynamic rewards;

  User({
    this.id,
    this.email,
    this.mobile,
    this.username,
    this.profileImage,
    this.profileStatus,
    this.status,
    this.referralCode,
    this.userKycStatus,
    this.userKycStatusMessage,
    this.isReward,
    this.rewards,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    mobile: json["mobile"],
    username: json["username"],
    profileImage: json["profile_image"],
    profileStatus: json["profile_status"],
    status: json["status"],
    referralCode: json["referral_code"],
    userKycStatus: json["user_kyc_status"],
    userKycStatusMessage: json["user_kyc_status_message"],
    isReward: json["is_reward"],
    rewards: json["rewards"],
  );

}
