
import 'dart:convert';

MobileOtpResponse mobileOtpResponseFromJson(String str) => MobileOtpResponse.fromJson(json.decode(str));


class MobileOtpResponse {
    final String? statusCode;
    final String? statusText;
    final String? message;
    final Data? data;

    MobileOtpResponse({
        this.statusCode,
        this.statusText,
        this.message,
        this.data,
    });

    factory MobileOtpResponse.fromJson(Map<String, dynamic> json) => MobileOtpResponse(
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
    final dynamic email;
    final String? mobile;
    final dynamic username;
    final String? profileImage;
    final int? status;
    final String? referralCode;
    final int? feeByLbm;
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
        this.status,
        this.referralCode,
        this.feeByLbm,
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
        status: json["status"],
        referralCode: json["referral_code"],
        feeByLbm: json["fee_by_lbm"],
        userKycStatus: json["user_kyc_status"],
        userKycStatusMessage: json["user_kyc_status_message"],
        isReward: json["is_reward"],
        rewards: json["rewards"],
    );
}
