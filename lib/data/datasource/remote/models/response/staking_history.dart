import 'dart:convert';

StakingHistory stakingHistoryFromJson(String str) => StakingHistory.fromJson(json.decode(str));


class StakingHistory {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  StakingHistory({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory StakingHistory.fromJson(Map<String, dynamic> json) => StakingHistory(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final int? currentPage;
  final List<StakingList>? data;
  final int? from;
  final int? to;
  final int? lastPage;
  final int? perPage;
  final int? total;

  Data({
    this.currentPage,
    this.data,
    this.from,
    this.to,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<StakingList>.from(json["data"]!.map((x) => StakingList.fromJson(x))),
    from: json["from"],
    to: json["to"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );

}

class StakingList {
  final String? stakeCurrency;
  final String? rewardCurrency;
  final List<PairDatum>? pairData;
  final String? stakeCurrencyImage;
  final String? rewardCurrencyImage;
  final int? totalActive;
  final int? totalLiquidity;

  StakingList({
    this.stakeCurrency,
    this.rewardCurrency,
    this.pairData,
    this.stakeCurrencyImage,
    this.rewardCurrencyImage,
    this.totalActive,
    this.totalLiquidity,
  });

  factory StakingList.fromJson(Map<String, dynamic> json) => StakingList(
    stakeCurrency: json["stake_currency"],
    rewardCurrency: json["reward_currency"],
    pairData: json["pair_data"] == null ? [] : List<PairDatum>.from(json["pair_data"]!.map((x) => PairDatum.fromJson(x))),
    stakeCurrencyImage: json["stake_currency_image"],
    rewardCurrencyImage: json["reward_currency_image"],
    totalActive: json["total_active"],
    totalLiquidity: json["total_liquidity"],
  );

}

class PairDatum {
  final int? id;
  final String? userId;
  final String? stakingPlanId;
  final String? amount;
  final DateTime? nextRoiDate;
  final DateTime? activationDate;
  final DateTime? expiryDate;
  final String? roiIncome;
  final String? roiInterval;
  final String? rewardCurrency;
  final String? stakeCurrency;
  final String? planType;
  final bool? isActive;
  final dynamic unactiveAt;
  final String? extra;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final StakingPlan? stakingPlan;

  PairDatum({
    this.id,
    this.userId,
    this.stakingPlanId,
    this.amount,
    this.nextRoiDate,
    this.activationDate,
    this.expiryDate,
    this.roiIncome,
    this.roiInterval,
    this.rewardCurrency,
    this.stakeCurrency,
    this.planType,
    this.isActive,
    this.unactiveAt,
    this.extra,
    this.createdAt,
    this.updatedAt,
    this.stakingPlan,
  });

  factory PairDatum.fromJson(Map<String, dynamic> json) => PairDatum(
    id: json["id"],
    userId: json["user_id"],
    stakingPlanId: json["staking_plan_id"],
    amount: json["amount"],
    nextRoiDate: json["next_roi_date"] == null ? null : DateTime.parse(json["next_roi_date"]),
    activationDate: json["activation_date"] == null ? null : DateTime.parse(json["activation_date"]),
    expiryDate: json["expiry_date"] == null ? null : DateTime.parse(json["expiry_date"]),
    roiIncome: json["roi_income"],
    roiInterval: json["roi_interval"],
    rewardCurrency: json["reward_currency"],
    stakeCurrency: json["stake_currency"],
    planType: json["plan_type"],
    isActive: json["is_active"],
    unactiveAt: json["unactive_at"],
    extra: json["extra"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    stakingPlan: json["staking_plan"] == null ? null : StakingPlan.fromJson(json["staking_plan"]),
  );
}

class StakingPlan {
  final int? id;
  final String? stakeCurrency;
  final String? rewardCurrency;
  final int? maturityDays;
  final String? roiPercentage;
  final String? minStakeAmount;
  final String? maxStakeAmount;

  StakingPlan({
    this.id,
    this.stakeCurrency,
    this.rewardCurrency,
    this.maturityDays,
    this.roiPercentage,
    this.minStakeAmount,
    this.maxStakeAmount,
  });

  factory StakingPlan.fromJson(Map<String, dynamic> json) => StakingPlan(
    id: json["id"],
    stakeCurrency: json["stake_currency"],
    rewardCurrency: json["reward_currency"],
    maturityDays: json["maturity_days"],
    roiPercentage: json["roi_percentage"],
    minStakeAmount: json["min_stake_amount"],
    maxStakeAmount: json["max_stake_amount"],
  );
}
