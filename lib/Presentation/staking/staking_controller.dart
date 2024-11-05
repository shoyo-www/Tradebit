import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/staking_repository_impl.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/wallet_repositoryImpl.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/reddem_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/staking_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/unsubscribe_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/stake_balance.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/staking.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/staking_history.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/transaction_history.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';

class StakingController extends GetxController {
  bool isLoading = false;
  bool buttonLoading = false;
  bool all = true;
  bool fixed = false;
  bool flexibleButton = true;
  bool nine = true;
  String? date;
  bool six = false;
  String estApr = '';
  bool three = false;
  int? planId;
  bool fixedButton = false;
  String availBal = '0.00';
  String stakeCurrency = 'MCOIN';
  String? image;
  bool firstTime = true;
  bool isVisible = false;
  bool flexible = false;
  bool holding = true;
  bool transactions = false;
  bool agreeButton = false;
  bool imageFirst = true;
  bool search = false;
  bool holdingSearch = false;
  bool transactionSearch = false;
  int selectedIndex = 0;
  bool buttonSearch = false;
  List <Datum> stakingList = [];
  List <Datum> filterList = [];
  String stakeBalance = '0.0';
  List <StakingList> stakingHistory = [];
  List <PairDatum> stakingHistoryFilter = [];
  List <Datum> fixedList = [];
  List <PairDatum> stakingHistorylength = [];
  List <Transaction> transactionsList = [];
  List <Transaction> transactionsListFilter = [];
  List<StakeBal> stakeBal = [];
  TextEditingController amountController = TextEditingController();
  final StakingRepositoryImpl _repository = StakingRepositoryImpl();
  final WalletRepositoryImpl walletRepositoryImpl = WalletRepositoryImpl();
  GlobalKey<FormState> stakingKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  int  currentPage = 1;
  bool hasMoreData = true;
  bool hasMoreDataTransaction = true;
  bool isLoadingMore = false;
  bool isLoadingMoreTransaction = false;

  @override
  onInit() {
    getStaking(Get.context!);
    super.onInit();
  }

  void filterSearchZero(String text) {
    holdingSearch = true;
    stakingHistoryFilter = stakingHistorylength.where((e) => e.stakeCurrency!.toUpperCase().contains(text.toUpperCase())).toList();
    update([ControllerBuilders.stakingController]);
  }

  void filterSearchTransaction(String text) {
    transactionSearch = true;
    transactionsListFilter = transactionsList.where((e) => e.currency!.toUpperCase().contains(text.toUpperCase())).toList();
    update([ControllerBuilders.stakingController]);
  }

  getBack(BuildContext context) {
    amountController.clear();
    Navigator.pop(context);
  }

  onAll() {
    all = true;
    fixed = false;
    flexible = false;
    update([ControllerBuilders.stakingController]);
  }

  onHolding() {
    holding = true;
    transactions = false;
    update([ControllerBuilders.stakingController]);
  }

  onTransactions() {
    holding = false;
    transactions = true;
    update([ControllerBuilders.stakingController]);
  }

  onAgreeButton() {
    agreeButton = !agreeButton;
    update([ControllerBuilders.stakingController]);
  }

  onFixed() {
    all = false;
    fixed = true;
    flexible = false;
    update([ControllerBuilders.stakingController]);
  }

  onFlexible() {
    all = false;
    fixed = false;
    flexible = true;
    update([ControllerBuilders.stakingController]);
  }
  onButtonNine(int id) {
    nine = true;
    six = false;
    planId = id;
    three = false;
    update([ControllerBuilders.stakingController]);
  }

  onIndex (int index, SData? s) {
    selectedIndex = index;
    if(selectedIndex == 0) {
      planId = s?.fixed365?.id ?? 0;
      estApr = s?.fixed365?.roiPercentage ?? '';
      update([ControllerBuilders.stakingController]);
    }
    else if(selectedIndex == 1) {
      planId = s?.fixed180?.id ?? 0;
      estApr = s?.fixed180?.roiPercentage ?? '';
      update([ControllerBuilders.stakingController]);
    }
    else if(selectedIndex == 2) {
      planId = s?.fixed90?.id ?? 0;
      estApr = s?.fixed90?.roiPercentage ?? '';
      update([ControllerBuilders.stakingController]);
    }
    update([ControllerBuilders.stakingController]);
  }


  onButtonFlexible(int id,String apr) {
    flexibleButton = true;
    fixedButton = false;
    isVisible = false;
    firstTime = false;
    estApr = apr;
    planId = id;
    update([ControllerBuilders.stakingController]);

  }

  onFixedButton(BuildContext context,String apr) {
    flexibleButton = false;
    fixedButton = true;
    isVisible = true;
    firstTime = false;
    estApr = apr;
    update([ControllerBuilders.stakingController]);

  }

  void showBottomSheetDeposit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: AppColor.transparent,
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                minChildSize: 0.2,
                maxChildSize: 0.3,
                builder: (_, controller) {
                  return Container(
                    padding: EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
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
                            TradeBitTextWidget(title: 'Select ', style: AppTextStyle.themeBoldNormalTextStyle(
                                color: Theme.of(context).shadowColor.withOpacity(0.5),
                                fontSize: FontSize.sp_18
                            )),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child:  Icon(Icons.close_rounded,color: Theme.of(context).shadowColor.withOpacity(0.5),)),
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_15),
                       Expanded(child: ListView.builder(
                         itemCount: stakeBal.length,
                           itemBuilder: (c,i) {
                         return Padding(
                           padding:  EdgeInsets.only(top: Dimensions.h_20),
                           child: GestureDetector(
                             onTap: () {
                               stakeCurrency = stakeBal[i].currency ?? '';
                               stakeBalance = stakeBal[i].withdrawable ?? '0.0';
                               amount.clear();
                               Navigator.of(context).pop();
                               update([ControllerBuilders.stakingController]);
                             },
                               child: SizedBox(
                                 width: double.infinity,
                                   child: TradeBitTextWidget(title: stakeBal[i].currency ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                     fontSize: FontSize.sp_14,
                                     color: Theme.of(context).highlightColor
                                   )))),
                         );
                       }))
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  onStakeMax() {
    amount.text = stakeBalance ?? '';
    update([ControllerBuilders.exchangeController]);
  }

  getFundStake(BuildContext context) async {
    isLoading = true;
    var data = await walletRepositoryImpl.stakeWallet();
    data.fold((l) {
      if (l is ServerFailure) {
        isLoading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.walletController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
       stakeBal.clear();
       stakeBal.addAll(r.data?.data ?? []);
       if(stakeBal.isNotEmpty) {
         stakeBalance = stakeBal[0].withdrawable == null ? '0.0': stakeBal[0].withdrawable ??  '0.0';
       }
       isLoading = false;
       update([ControllerBuilders.stakingController]);

      } else {
        isLoading = false;
        ToastUtils.showCustomToast(context, message, false);
        update([ControllerBuilders.walletController]);
      }
    });
    update([ControllerBuilders.walletController]);
  }
  
  void filterSearch(String text) {
    filterList = fixed ? fixedList.where((e) => e.stakeCurrency?.contains(text.toUpperCase()) ?? false).toList() : stakingList
        .where((e) => e.stakeCurrency?.contains(text.toUpperCase()) ?? false)
        .toList();
    search = true;
    update([ControllerBuilders.stakingController]);
    if(text.isEmpty) {
      search = false;
      update([ControllerBuilders.stakingController]);
    }
    update([ControllerBuilders.stakingController]);
  }

  onSearchButton() {
    buttonSearch = !buttonSearch;
    search = false;
    update([ControllerBuilders.stakingController]);
  }


  getStaking(BuildContext context) async {
    isLoading = true;
    var data = await _repository.staking();
    data.fold((l) {
      if (l is ServerFailure) {
        isLoading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.stakingController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        stakingList.clear();
        filterList.clear();
        fixedList.clear();
        stakingList.addAll(r.data?.data ?? []);
        for(var i in stakingList) {
          if(i.oPlanDays?.fixed?.isNotEmpty ?? false) {
            print(i);
            fixedList.add(i);
            update([ControllerBuilders.stakingController]);
          }
        }
        filterList = stakingList;
        isLoading = false;
        update([ControllerBuilders.stakingController]);

      } else {
        isLoading = false;
        ToastUtils.showCustomToast(context, message, false);
        update([ControllerBuilders.stakingController]);
      }
    });
    update([ControllerBuilders.stakingController]);
  }
   int transactionPage = 1;

  getStakingTransactions(BuildContext context) async {
    if (transactionPage == 1) {
      isLoading = true;
    }
    var data = await _repository.transactionHistory(transactionPage);
    data.fold((l) {
      if (l is ServerFailure) {
        isLoading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.stakingController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        if (transactionPage == 1) {
          transactionsList.clear();
          transactionsListFilter.clear();
        }
        transactionsList.addAll(r.data?.data ?? []);
        transactionsListFilter.addAll(transactionsList);
        isLoading = false;
        if ((r.data?.data?.length ?? 0) < 10) { // assuming 10 items per page
          hasMoreDataTransaction = false;
        }
        transactionPage++;
        update([ControllerBuilders.stakingController]);
      } else {
        isLoading = false;
        ToastUtils.showCustomToast(context, message, false);
        update([ControllerBuilders.stakingController]);
      }
    });
    update([ControllerBuilders.stakingController]);
  }

  loadMoreTransaction(BuildContext context) async {
    if (isLoadingMoreTransaction || !hasMoreDataTransaction) return;
    isLoadingMoreTransaction = true;
    update([ControllerBuilders.stakingController]);
    await getStakingTransactions(context);
    isLoadingMoreTransaction = false;
    update([ControllerBuilders.stakingController]);
  }


  cancelOrderDailog(BuildContext context, StakingController controller, int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
              insetPadding: EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
              contentPadding: EdgeInsets.zero,
              content: TradeBitContainer(
                padding: EdgeInsets.only(
                  top: Dimensions.h_15,
                  bottom: Dimensions.h_10,
                  left: Dimensions.w_15,
                  right: Dimensions.w_15,
                ),
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.h_15)),
                child: GetBuilder(
                  init: controller,
                  id: ControllerBuilders.stakingController,
                  builder: (controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TradeBitTextWidget(
                            title: 'Unsubscribe ',
                            style: AppTextStyle
                                .themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_16,
                                color: Theme.of(context).highlightColor)),
                        VerticalSpacing(height: Dimensions.h_10),
                        TradeBitTextWidget(
                            title: 'are your sure you want to unsubscribe ?',
                            style: AppTextStyle.normalTextStyle(
                                FontSize.sp_14, Theme.of(context).shadowColor)),
                        VerticalSpacing(height: Dimensions.h_20),
                        Row(
                          children: [
                            Expanded(child: TradeBitTextButton(loading: controller.buttonLoading,borderRadius: BorderRadius.circular(Dimensions.h_5),height: Dimensions.h_30,margin: EdgeInsets.zero,labelName: 'Yes', onTap: () {
                              controller.buttonLoading ? null :  controller.stakingUnsub(context, id);
                            },color: AppColor.appColor)),
                            HorizontalSpacing(width: Dimensions.w_10),
                            Expanded(child: TradeBitTextButton(borderRadius: BorderRadius.circular(Dimensions.h_5),height: Dimensions.h_30,margin: EdgeInsets.zero,labelName: 'NO', onTap: () {
                              Navigator.of(context).pop();
                            },color:Theme.of(context).scaffoldBackgroundColor)),
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_10),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        });
    update([ControllerBuilders.stakingController]);
  }

  getStakingData() {
    currentPage = 1;
    stakingHistory.clear();
    update([ControllerBuilders.stakingController]);
  }
  getStakingHistory(BuildContext context) async {
    if (currentPage == 1) {
      isLoading = true;
    }
    var data = await _repository.stakingHistory(currentPage);
    data.fold((l) {
      if (l is ServerFailure) {
        isLoading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.stakingController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        if (currentPage == 1) {
          stakingHistory.clear();
          stakingHistorylength.clear();
        }
        stakingHistory.addAll(r.data?.data ?? []);
        for (var i in stakingHistory) {
          if(imageFirst == true) {
            image = i.rewardCurrencyImage ?? '';
            imageFirst = false;
          }
          stakingHistorylength.addAll(i.pairData ?? []);
        }
        isLoading = false;
        if ((r.data?.data?.length ?? 0) < 10) { // assuming 10 items per page
          hasMoreData = false;
        }
        currentPage++;
        update([ControllerBuilders.stakingController]);
      } else {
        isLoading = false;
        ToastUtils.showCustomToast(context, message, false);
        update([ControllerBuilders.stakingController]);
      }
    });
    update([ControllerBuilders.stakingController]);
  }

  getStakingTransaction(BuildContext context) async {
    if (currentPage == 1) {
      isLoading = true;
    }
    var data = await _repository.stakingHistory(currentPage);
    data.fold((l) {
      if (l is ServerFailure) {
        isLoading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.stakingController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        if (currentPage == 1) {
          stakingHistory.clear();
          stakingHistorylength.clear();
        }
        stakingHistory.addAll(r.data?.data ?? []);
        for (var i in stakingHistory) {
          if(imageFirst == true) {
            image = i.rewardCurrencyImage ?? '';
            imageFirst = false;
          }
          stakingHistorylength.addAll(i.pairData ?? []);
        }
        isLoading = false;
        if ((r.data?.data?.length ?? 0) < 10) { // assuming 10 items per page
          hasMoreData = false;
        }
        currentPage++;
        update([ControllerBuilders.stakingController]);
      } else {
        isLoading = false;
        ToastUtils.showCustomToast(context, message, false);
        update([ControllerBuilders.stakingController]);
      }
    });
    update([ControllerBuilders.stakingController]);
  }

  loadMore(BuildContext context) async {
    if (isLoadingMore || !hasMoreData) return;
    isLoadingMore = true;
    await getStaking(context);
    isLoadingMore = false;
  }

  onMax() {
  amountController.text = availBal;
  update([ControllerBuilders.stakingController]);
  }

  getId(int planIDnew) {
    planIDnew = planId ?? 0;
    update([ControllerBuilders.stakingController]);
  }

  getFund(BuildContext context,String symbol) async {
    var data = await walletRepositoryImpl.walletSymbol(symbol);
    data.fold((l) {
      if (l is ServerFailure) {
        update([ControllerBuilders.stakingController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        availBal = r.data?.wallets?.spot?.quantity ?? '';
        print('===============================///////???????$availBal');
        update([ControllerBuilders.stakingController]);
      } else {
        update([ControllerBuilders.stakingController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.stakingController]);
  }

  stakingSub(BuildContext context) async {
    if(amountController.text.isNotEmpty && agreeButton == true) {
      double enteredAmount = double.parse(amountController.text);
      double availableAmount = double.parse(availBal);
      if (enteredAmount > availableAmount) {
        ToastUtils.showCustomToast(context, 'Not enough balance', false);
        return;
      }
      buttonLoading = true;
      update([ControllerBuilders.stakingController]);
      var request = StakingSubscribeRequest(
          amount: amountController.text,
          planId: planId ?? 0
      );
      var data = await _repository.stakingSub(request);
      data.fold((l) {
        if (l is ServerFailure) {
          buttonLoading = false;
          ToastUtils.showCustomToast(context, l.message ?? '', false);
          update([ControllerBuilders.stakingController]);
        }
      }, (r) {
        String code = r.statusCode ?? '';
        String message = r.message ?? '';
        if (code == '1') {
          amountController.clear();
          buttonLoading = false;
          ToastUtils.showCustomToast(context, message, true);
          pushReplacementWithSlideTransition(context,DashBoard(index: 4),isBack: true);
          update([ControllerBuilders.stakingController]);
        }
        else {
          buttonLoading = false;
          update([ControllerBuilders.stakingController]);
          ToastUtils.showCustomToast(context, message, false);
        }
      }
      );
      update([ControllerBuilders.stakingController]);
    }
     else {
       if(amountController.text.isEmpty) {
         ToastUtils.showCustomToast(context, 'Please enter amount', false);
       } else {
         ToastUtils.showCustomToast(context, 'Select agree button', false);
       }

       update([ControllerBuilders.stakingController]);
    }
    update([ControllerBuilders.stakingController]);
  }

  stakingUnsub(BuildContext context,int id) async {
    buttonLoading = true;
    update([ControllerBuilders.stakingController]);
      var request = StakingUnsubscribeRequest(
          userStakeId: id
      );
      var data = await _repository.stakingUnsubscribe(request);
      data.fold((l) {
        if (l is ServerFailure) {
          buttonLoading = false;
          ToastUtils.showCustomToast(context, l.message ?? '', false);
          update([ControllerBuilders.stakingController]);
        }
      }, (r) async {
        String code = r.statusCode ?? '';
        String message = r.message ?? '';
        if (code == '1') {
          await getStakingHistory(context);
          buttonLoading = false;
          Navigator.pop(context);
          ToastUtils.showCustomToast(context, message, true);
          update([ControllerBuilders.stakingController]);
        }
        else {
          Navigator.pop(context);
          buttonLoading = false;
          update([ControllerBuilders.stakingController]);
          ToastUtils.showCustomToast(context, message, false);
        }
      }
      );
      update([ControllerBuilders.stakingController]);
    }

  redeem(BuildContext context) async {
    double enteredAmount = double.parse(amount.text);
    double availableAmount = double.parse(stakeBalance);
    if (enteredAmount > availableAmount) {
      ToastUtils.showCustomToast(context, 'Not enough balance', false);
      return;
    }
    buttonLoading = true;
    update([ControllerBuilders.stakingController]);
    var request = RedeemRequest(amount: amount.text, currency: stakeCurrency);
    var data = await _repository.redeem(request);
    data.fold((l) {
      if (l is ServerFailure) {
        buttonLoading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.stakingController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        buttonLoading = false;
        amount.clear();
        ToastUtils.showCustomToast(context, message, true);
        update([ControllerBuilders.stakingController]);
      }
      else {
        buttonLoading = false;
        update([ControllerBuilders.stakingController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    }
    );
    update([ControllerBuilders.stakingController]);
  }
  }
