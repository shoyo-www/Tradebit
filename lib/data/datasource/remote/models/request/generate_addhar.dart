import 'dart:convert';

String generateKycOtpRequestToJson(GenerateKycOtpRequest data) => json.encode(data.toJson());

class GenerateKycOtpRequest {
  final String? countryCode;
  final String? documentType;
  final String? documentNumber;

  GenerateKycOtpRequest({
    this.countryCode,
    this.documentType,
    this.documentNumber,
  });


  Map<String, dynamic> toJson() => {
    "country_code": countryCode,
    "document_type": documentType,
    "document_number": documentNumber,
  };
}