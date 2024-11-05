import 'dart:convert';


String transferOtpRequestToJson(TransferOtpRequest data) => json.encode(data.toJson());

class TransferOtpRequest {
  final String? type;

  TransferOtpRequest({
    this.type,
  });


  Map<String, dynamic> toJson() => {
    "type": type,
  };
}