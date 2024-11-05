import 'dart:convert';

String stakingSubscribe(StakingSubscribeRequest data) => json.encode(data.toJson());

class StakingSubscribeRequest {
  int planId;
  String amount;


  StakingSubscribeRequest({
    required this.planId,
    required this.amount,
  });


  Map<String, dynamic> toJson() => {
    "staking_plan_id": planId,
    "amount": amount,
  };
}
