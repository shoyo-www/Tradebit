import 'dart:convert';

TransactionHistory transactionHistoryFromJson(String str) => TransactionHistory.fromJson(json.decode(str));


class TransactionHistory {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  TransactionHistory({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) => TransactionHistory(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final int? currentPage;
  final List<Transaction>? data;
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
    data: json["data"] == null ? [] : List<Transaction>.from(json["data"]!.map((x) => Transaction.fromJson(x))),
    from: json["from"],
    to: json["to"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );

}

class Transaction {
  final int? id;
  final String? userId;
  final String? userStakeId;
  final String? currency;
  final String? transactionType;
  final String? previousBalance;
  final String? debit;
  final String? credit;
  final String? balance;
  final String? comment;
  final String? withdrawable;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? currencyImage;

  Transaction({
    this.id,
    this.userId,
    this.userStakeId,
    this.currency,
    this.transactionType,
    this.previousBalance,
    this.debit,
    this.credit,
    this.balance,
    this.comment,
    this.withdrawable,
    this.createdAt,
    this.updatedAt,
    this.currencyImage,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    userId: json["user_id"],
    userStakeId: json["user_stake_id"],
    currency: json["currency"],
    transactionType: json["transaction_type"],
    previousBalance: json["previous_balance"],
    debit: json["debit"],
    credit: json["credit"],
    balance: json["balance"],
    comment: json["comment"],
    withdrawable: json["withdrawable"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    currencyImage: json["currency_image"],
  );

}

