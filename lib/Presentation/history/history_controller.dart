import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/wallet_repositoryImpl.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';

import '../../data/datasource/remote/models/response/history_response.dart';

class HistoryController extends GetxController {

  int selectedIndex = 0;
  bool loading = false;
  String type = 'Deposit';
  List<Datum> deposit = [];
  List<Datum> withdraw = [];
  List<Datum> send = [];
  List<Datum> transfer = [];
  List <String> categories = ['Deposit', 'Withdrawal','Send', 'Transfer',];
  final WalletRepositoryImpl walletRepositoryImpl = WalletRepositoryImpl();

  getIndex(int index,BuildContext context,String t) {
    selectedIndex = index;
    type = t;
    getHistory(context);
    update([ControllerBuilders.historyController]);
  }

 getHistory(BuildContext context) async {
    loading = true;
     var data = await walletRepositoryImpl.history(type.toLowerCase());
     data.fold((l) {
       if (l is ServerFailure) {
         loading =false;
         update([ControllerBuilders.historyController]);
       }
     }, (r) {
       String code = r.statusCode ?? '';
       String message = r.message ?? '';
       if (code == '1') {
         if(type == 'Deposit') {
           deposit.clear();
           deposit.addAll(r.data?.data ?? []);
           print(deposit);
           update([ControllerBuilders.historyController]);
         } else if(type == 'Withdrawal') {
           withdraw.clear();
           withdraw.addAll(r.data?.data ?? []);
           print(withdraw);
           update([ControllerBuilders.historyController]);
         }else if(type == 'Send') {
           send.clear();
           send.addAll(r.data?.data ?? []);
           print(send);
           update([ControllerBuilders.historyController]);
         }else {
           transfer.clear();
           transfer.addAll(r.data?.data ?? []);
           print(transfer);
           update([ControllerBuilders.historyController]);
         }
         loading = false;
         update([ControllerBuilders.historyController]);
       } else {
         loading = false;
         ToastUtils.showCustomToast(context, message, false);
         update([ControllerBuilders.historyController]);
       }
     });
     update([ControllerBuilders.historyController]);
   }
 }
