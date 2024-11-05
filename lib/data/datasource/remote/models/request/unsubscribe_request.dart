import 'dart:convert';

String stakingUnsubscribeRequestToJson(StakingUnsubscribeRequest data) => json.encode(data.toJson());

class StakingUnsubscribeRequest {
  final int? userStakeId;

  StakingUnsubscribeRequest({
    this.userStakeId,
  });

  Map<String, dynamic> toJson() => {
    "user_stake_id": userStakeId,
  };
}
