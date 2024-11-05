import 'dart:convert';

TransferResponse transferResponseFromJson(String str) => TransferResponse.fromJson(json.decode(str));

class TransferResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  TransferResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory TransferResponse.fromJson(Map<String, dynamic> json) => TransferResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final String? user;
  final String? amount;
  final String? currency;
  final String? walletType;
  final String? type;
  final String? emailVcode;
  final String? mobileVcode;
  final String? googleVcode;
  final List<VerifyCheckList>? verifyCheckList;

  Data({
    this.user,
    this.amount,
    this.currency,
    this.walletType,
    this.type,
    this.emailVcode,
    this.mobileVcode,
    this.googleVcode,
    this.verifyCheckList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"],
    amount: json["amount"],
    currency: json["currency"],
    walletType: json["wallet_type"],
    type: json["type"],
    emailVcode: json["email_vcode"],
    mobileVcode: json["mobile_vcode"],
    googleVcode: json["google_vcode"],
    verifyCheckList: json["verifyCheckList"] == null ? [] : List<VerifyCheckList>.from(json["verifyCheckList"]!.map((x) => VerifyCheckList.fromJson(x))),
  );

}

class VerifyCheckList {
  final String? type;
  final String? verifyMask;

  VerifyCheckList({
    this.type,
    this.verifyMask,
  });

  factory VerifyCheckList.fromJson(Map<String, dynamic> json) => VerifyCheckList(
    type: json["type"],
    verifyMask: json["verifyMask"],
  );

}
