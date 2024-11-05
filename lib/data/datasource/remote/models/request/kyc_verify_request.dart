
import 'dart:convert';

String kycVerifyRequestToJson(KycVerifyRequest data) => json.encode(data.toJson());

class KycVerifyRequest {
  final String firstName;
  final String lastName;
  final String dateBirth;
  final String address;
  final String identityType;
  final String identityNumber;
  final String otpCode;
  final String refId;
  final String accessToken;
  final String identityFrontPath;
  final String identityBackPath;

  KycVerifyRequest({
    required this.firstName,
    required this.lastName,
    required this.dateBirth,
    required this.address,
    required this.identityType,
    required this.identityNumber,
    required this.otpCode,
    required this.refId,
    required this.accessToken,
    required this.identityFrontPath,
    required this.identityBackPath,
  });


  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "date_birth": dateBirth,
    "address": address,
    "identity_type": identityType,
    "identity_number": identityNumber,
    "otp_code": otpCode,
    "ref_id": refId,
    "access_token": accessToken,
    "identity_front_path": identityFrontPath,
    "identity_back_path": identityBackPath,
  };
}
