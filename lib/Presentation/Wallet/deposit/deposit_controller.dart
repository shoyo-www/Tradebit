import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit_screen.dart';
import 'package:tradebit_app/Presentation/Wallet/wallet_controller.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/wallet_repositoryImpl.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/wallet_create.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/walletListResponse.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

import '../../../constants/appcolor.dart';

class DepositController extends GetxController {
 String? image;
 String? symbol;
 String? walletAddress;
 String? minDeposit;
 bool search = false;
 bool withdrawSearch = false;
 bool firstTime = true;
 List<CurrencyNetwork> network = [];
 final TextEditingController searchController = TextEditingController();
 String? tokenType;
 List<Datum> depositList = [];
 List<Datum> withdrawList = [];
 List<Datum> filterList = [];
 List<Datum> withdrawFilter = [];
 final WalletRepositoryImpl _walletRepositoryImpl = WalletRepositoryImpl();
 bool isLoading = false;
 final WalletController walletController = WalletController();

 @override
  void onInit() {
   getCrypto(Get.context!);
    super.onInit();
  }

 void onSearchTap() {
  search = false;
  withdrawSearch = false;
  searchController.clear();
  update([ControllerBuilders.depositController]);
 }

 void filterSearch(String text) {
  search = true;
  filterList = depositList.where((e) => e.symbol!.toUpperCase().contains(text.toUpperCase())).toList();
  if(text.isEmpty) {
   search = false;
   update([ControllerBuilders.depositController]);
  }
  update([ControllerBuilders.depositController]);
 }

 void filterSearchWithdraw(String text) {
  withdrawSearch = true;
  withdrawFilter = withdrawList.where((e) => e.symbol!.toUpperCase().contains(text.toUpperCase())).toList();
  if(text.isEmpty) {
   withdrawSearch = false;
   update([ControllerBuilders.depositController]);
  }
  update([ControllerBuilders.depositController]);
 }

 depositget() {
  firstTime = true;
  update([ControllerBuilders.depositController]);
 }


 createWallet(BuildContext context,String currencyId,String networkId) async {
  isLoading = true;
  update([ControllerBuilders.depositController]);
  var req = WalletCreateRequest(currencyId: currencyId, networkId: networkId, tokenType: tokenType ?? '');
  var data = await _walletRepositoryImpl.walletCreate(req);
  data.fold((l) {
   if (l is ServerFailure) {
    isLoading = false;
    ToastUtils.showCustomToast(context, l.message ?? '', false);
    update([ControllerBuilders.depositController]);
   }
  }, (r) async {
   if(r.statusCode == '1') {
    isLoading = false;
    await getCrypto(context);
    ToastUtils.showCustomToast(context, r.message ?? '', true);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const DepositScreen()));
    update([ControllerBuilders.walletController]);
    update([ControllerBuilders.depositController]);
   }else {
    isLoading = false;
    ToastUtils.showCustomToast(context, r.message ?? '', false);
    update([ControllerBuilders.depositController]);
   }

  });
  update([ControllerBuilders.depositController]);
 }

 getCrypto(BuildContext context) async {
  isLoading = true;
  var data = await _walletRepositoryImpl.wallet();
  data.fold((l) {
   if (l is ServerFailure) {
    isLoading = false;
    ToastUtils.showCustomToast(context, l.message ?? '', false);
    update([ControllerBuilders.depositController]);
   }
  }, (r) {
   String code = r.statusCode ?? '';
   String message = r.message ?? '';
   if (code == '1') {
    depositList.clear();
    filterList.clear();
    withdrawList.clear();
    withdrawFilter.clear();
    update([ControllerBuilders.depositController]);
    for(int i = 0; i< (r.data?.length ?? 0); i++) {
     if(r.data?[i].depositEnable == true) {
      depositList.add(r.data![i]);
     }
    }
    for(int i = 0; i< (r.data?.length ?? 0); i++) {
     if(r.data?[i].withdrawEnable == true) {
      withdrawList.add(r.data![i]);
     }
    }
    withdrawFilter.addAll(withdrawList);
    log(depositList.toString());
    filterList = depositList;
    image = r.data?[0].image ?? '';
    symbol = r.data?[0].symbol ?? '';
    walletAddress = r.data?[0].currencyNetworks?[0].walletAddress ?? '';
    walletController.walletAddress = r.data?[0].currencyNetworks?[0].walletAddress ?? '';
    tokenType = r.data?[0].currencyNetworks?[0].tokenType ?? '';
    minDeposit = r.data?[0].currencyNetworks?[0].depositMin ?? '';
    isLoading = false;
    update([ControllerBuilders.depositController]);
    update([ControllerBuilders.walletController]);
   } else {
    isLoading = false;
    update([ControllerBuilders.depositController]);
    ToastUtils.showCustomToast(context, message, false);
   }
  });
  update([ControllerBuilders.depositController]);
 }

 onShareButton(String symbol) async {
  await Share.share(
      'My Public Address to receive $symbol ($tokenType) - $walletAddress');
  update([ControllerBuilders.depositController]);
 }

 onCopyClipBoard(BuildContext context) {
  Clipboard.setData(ClipboardData(text: walletAddress.toString())).then((_) {
   ToastUtils.showCustomToast(context, 'Copied successfully', true);
  });
  update([ControllerBuilders.depositController]);
 }

 void showBottomSheetDeposit(BuildContext context,List<CurrencyNetwork>? network) {
  showModalBottomSheet(
   context: context,
   isDismissible: false,
   enableDrag: false,
   elevation: 0,
   isScrollControlled: true,
   backgroundColor: Colors.transparent,
   builder: (context) {
    return WillPopScope(
      onWillPop: () async {
       return false;
      },
      child: Container(
       color: AppColor.transparent,
       child: DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.75,
        builder: (_, controller) {
         return Container(
          padding: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20),
          decoration: BoxDecoration(
           color: Theme.of(context).cardColor,
           borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
           ),
          ),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            VerticalSpacing(height: Dimensions.h_20),
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TradeBitTextWidget(title: 'Select Network', style: AppTextStyle.themeBoldNormalTextStyle(
                 color: Theme.of(context).highlightColor,
                 fontSize: FontSize.sp_20
                )),
              ],
            ),
            VerticalSpacing(height: Dimensions.h_15),
            Expanded(
             child: ListView.separated(
              controller: controller,
              itemCount: network?.length ?? 0,
              itemBuilder: (_, index) {
               return network?[index].depositEnable == false ? const SizedBox.shrink(): GestureDetector(
                onTap: () {
                 tokenType = getSelf(network?[index].tokenType ?? '');
                 firstTime = false;
                 walletAddress = network?[index].walletAddress;
                 update([ControllerBuilders.depositController]);
                 Get.back();
                },
                child: TradeBitContainer(
                 margin: const EdgeInsets.only(top: 5,bottom: 5,left: 5,right: 5),
                 height: Dimensions.h_35,
                 padding: const EdgeInsets.all(10),
                 decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                 ),
                    child: Align(
                        alignment: Alignment.centerLeft ,
                        child: Text(getSelf(network?[index].tokenType ?? '')))),
               );
              }, separatorBuilder: (BuildContext context, int index) {
               return network?[index].depositEnable == false ? const SizedBox.shrink() :const Divider();
             },
             ),
            ),
           ],
          ),
         );
        },
       ),
      ),
    );
   },
  );
 }
 getSelf(String token) {
  if(token == 'SELF') {
   return 'MCOIN20';
  } else if(token == 'ETH') {
   return 'ERC20';
  } else if(token == 'TRX') {
   return 'TRC20';
  }
  return token;
 }
}
