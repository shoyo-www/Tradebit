import 'dart:convert';

String feesRequestToJson(FeesRequest data) => json.encode(data.toJson());

class FeesRequest {
  final int? feeByLbm;

  FeesRequest({
    this.feeByLbm,
  });

  factory FeesRequest.fromJson(Map<String, dynamic> json) => FeesRequest(
    feeByLbm: json["fee_by_lbm"],
  );

  Map<String, dynamic> toJson() => {
    "fee_by_lbm": feeByLbm,
  };
}
