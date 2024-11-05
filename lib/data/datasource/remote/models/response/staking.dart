import 'dart:convert';

StakingResponse stakingResponseFromJson(String str) => StakingResponse.fromJson(json.decode(str));

String stakingResponseToJson(StakingResponse data) => json.encode(data.toJson());

class StakingResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  StakingResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory StakingResponse.fromJson(Map<String, dynamic> json) => StakingResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_text": statusText,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final int? currentPage;
  final List<Datum>? data;
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
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    from: json["from"],
    to: json["to"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "from": from,
    "to": to,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
  };
}

class Datum {
  final String? stakeCurrency;
  final String? rewardCurrency;
  final String? stakeCurrencyImage;
  final String? rewardCurrencyImage;
  final String? selectedPlanType;
  final List<String>? aPlanTypes;
  final OPlanDays? oPlanDays;
  final int? sMaturityDays;
  final SData? sData;

  Datum({
    this.stakeCurrency,
    this.rewardCurrency,
    this.stakeCurrencyImage,
    this.rewardCurrencyImage,
    this.selectedPlanType,
    this.aPlanTypes,
    this.oPlanDays,
    this.sMaturityDays,
    this.sData,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    stakeCurrency: json["stake_currency"],
    rewardCurrency: json["reward_currency"],
    stakeCurrencyImage: json["stake_currency_image"],
    rewardCurrencyImage: json["reward_currency_image"],
    selectedPlanType: json["selected_plan_type"],
    aPlanTypes: json["a_plan_types"] == null ? [] : List<String>.from(json["a_plan_types"]!.map((x) => x)),
    oPlanDays: json["o_plan_days"] == null ? null : OPlanDays.fromJson(json["o_plan_days"]),
    sMaturityDays: json["s_maturity_days"],
    sData: json["s_data"] == null ? null : SData.fromJson(json["s_data"]),
  );

  Map<String, dynamic> toJson() => {
    "stake_currency": stakeCurrency,
    "reward_currency": rewardCurrency,
    "stake_currency_image": stakeCurrencyImage,
    "reward_currency_image": rewardCurrencyImage,
    "selected_plan_type": selectedPlanType,
    "a_plan_types": aPlanTypes == null ? [] : List<dynamic>.from(aPlanTypes!.map((x) => x)),
    "o_plan_days": oPlanDays?.toJson(),
    "s_maturity_days": sMaturityDays,
    "s_data": sData?.toJson(),
  };
}

class OPlanDays {
  final List<int>? flexible;
  final List<int>? fixed;

  OPlanDays({
    this.flexible,
    this.fixed,
  });

  factory OPlanDays.fromJson(Map<String, dynamic> json) => OPlanDays(
    flexible: json["flexible"] == null ? [] : List<int>.from(json["flexible"]!.map((x) => x)),
    fixed: json["fixed"] == null ? [] : List<int>.from(json["fixed"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "flexible": flexible == null ? [] : List<dynamic>.from(flexible!.map((x) => x)),
    "fixed": fixed == null ? [] : List<dynamic>.from(fixed!.map((x) => x)),
  };
}

class SData {
  final Fixed180? flexible365;
  final Fixed180? fixed365;
  final Fixed180? fixed180;
  final Fixed180? fixed90;

  SData({
    this.flexible365,
    this.fixed365,
    this.fixed180,
    this.fixed90,
  });

  factory SData.fromJson(Map<String, dynamic> json) => SData(
    flexible365: json["flexible-365"] == null ? null : Fixed180.fromJson(json["flexible-365"]),
    fixed365: json["fixed-365"] == null ? null : Fixed180.fromJson(json["fixed-365"]),
    fixed180: json["fixed-180"] == null ? null : Fixed180.fromJson(json["fixed-180"]),
    fixed90: json["fixed-90"] == null ? null : Fixed180.fromJson(json["fixed-90"]),
  );

  Map<String, dynamic> toJson() => {
    "flexible-365": flexible365?.toJson(),
    "fixed-365": fixed365?.toJson(),
    "fixed-180": fixed180?.toJson(),
    "fixed-90": fixed90?.toJson(),
  };
}

class Fixed180 {
  final int? id;
  final String? title;
  final String? description;
  final String? image;
  final String? stakeCurrency;
  final String? rewardCurrency;
  final String? planType;
  final int? maturityDays;
  final String? roiPercentage;
  final String? roiInterval;
  final String? minStakeAmount;
  final String? maxStakeAmount;
  final String? poolLimit;
  final int? planExpiryDays;
  final DateTime? planStartDate;
  final dynamic planExpiryDate;
  final int? isExpired;
  final int? activateStatus;
  final String? extra;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? stakeCurrencyImage;
  final String? rewardCurrencyImage;

  Fixed180({
    this.id,
    this.title,
    this.description,
    this.image,
    this.stakeCurrency,
    this.rewardCurrency,
    this.planType,
    this.maturityDays,
    this.roiPercentage,
    this.roiInterval,
    this.minStakeAmount,
    this.maxStakeAmount,
    this.poolLimit,
    this.planExpiryDays,
    this.planStartDate,
    this.planExpiryDate,
    this.isExpired,
    this.activateStatus,
    this.extra,
    this.createdAt,
    this.updatedAt,
    this.stakeCurrencyImage,
    this.rewardCurrencyImage,
  });

  factory Fixed180.fromJson(Map<String, dynamic> json) => Fixed180(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    stakeCurrency: json["stake_currency"],
    rewardCurrency: json["reward_currency"],
    planType: json["plan_type"],
    maturityDays: json["maturity_days"],
    roiPercentage: json["roi_percentage"],
    roiInterval: json["roi_interval"],
    minStakeAmount: json["min_stake_amount"],
    maxStakeAmount: json["max_stake_amount"],
    poolLimit: json["pool_limit"],
    planExpiryDays: json["plan_expiry_days"],
    planStartDate: json["plan_start_date"] == null ? null : DateTime.parse(json["plan_start_date"]),
    planExpiryDate: json["plan_expiry_date"],
    isExpired: json["is_expired"],
    activateStatus: json["activate_status"],
    extra: json["extra"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    stakeCurrencyImage: json["stake_currency_image"],
    rewardCurrencyImage: json["reward_currency_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "stake_currency": stakeCurrency,
    "reward_currency": rewardCurrency,
    "plan_type": planType,
    "maturity_days": maturityDays,
    "roi_percentage": roiPercentage,
    "roi_interval": roiInterval,
    "min_stake_amount": minStakeAmount,
    "max_stake_amount": maxStakeAmount,
    "pool_limit": poolLimit,
    "plan_expiry_days": planExpiryDays,
    "plan_start_date": "${planStartDate!.year.toString().padLeft(4, '0')}-${planStartDate!.month.toString().padLeft(2, '0')}-${planStartDate!.day.toString().padLeft(2, '0')}",
    "plan_expiry_date": planExpiryDate,
    "is_expired": isExpired,
    "activate_status": activateStatus,
    "extra": extra,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "stake_currency_image": stakeCurrencyImage,
    "reward_currency_image": rewardCurrencyImage,
  };
}
