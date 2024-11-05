import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit_screen.dart';
import 'package:tradebit_app/Presentation/Wallet/withdraw/withdraw_list.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/history/history.dart';
import 'package:tradebit_app/Presentation/transfer/transfer.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/staking_repository_impl.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/wallet_repositoryImpl.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/local/wallet_list_modal.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/wallet_create.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/crypto_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/stake_balance.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/staking_history.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import '../../data/datasource/remote/models/response/walletListResponse.dart';

class WalletController extends GetxController {
  bool isLoading = false;
  bool walletGenerate = false;
  bool walletLoading = false;
  final List<Datum>? walletList = [];
  List<Datum> zeroFilterListSpot = [];
  List<Datum> zeroFilterListFund = [];
  List<Datum> zeroFilterList = [];
  List<Datum> zeroFilterFund = [];
  List<PairDatum> filterListStaking = [];
  List <StakingList> stakingHistory = [];
  List <PairDatum> stakingHistorylength = [];
  List<Btc> usdt = [];
  List<Btc> showList = [];
  String totalBal = '0';
  String spotBalance = '0.0';
  String stakeWalletBalance = '0.0';
  String fundBalance = '0.0';
  bool firstTimeData = true;
  bool stakeFirst = true;
  double dstakeBalance = 0;
  double freezeFund = 0;
  double freezeSpotQ = 0;
  double stakeWallet = 0;
  double dspotBalance = 0;
  double dfundBalance = 0;
  double dfundqty = 0;
  double dspotqty = 0;
  double dstakeqty = 0;
  double spotFreezeBal = 0;
  double spotFreezeQ = 0;
  double fundFreezeB = 0;
  double fundFreezeQun = 0;
  double total = 0;
  double totalQty = 0;
  String allQty = '0';
  String stakeBalance = '0.0';
  String spotQuantity = '0.0';
  String freezeBal = '0.0';
  String fundQuant = '0.0';
  String stakeQuantity = '0.0';
  String fcBal = '0.0';
  String freezeSpotQuantity = '0.0';
  String freezeFundPrice = '0.0';
  String freezeFundingQuantity = '0.0';
  String freezeSpotBal = '0.0';
  bool deposit = true;
  bool withdraw = false;
  List<Datum> filterList = [];
  List<Datum> filterListZero = [];
  bool search = false;
  bool zeroSearchFund = false;
  bool zeroSearchSpot = false;
  bool stakingSearch = false;
  bool hidePrice = false;
  bool firstTime = true;
  bool spot = false;
  bool funding = false;
  bool staking = false;
  String? networkType;
  int selectedCategoryIndex = 0;
  int currentIndex = 0;
  bool hideZeroBalance = false;
  bool imageFirst = true;
  String? image;
  String? walletAddress ;
  List<StakeBal>? stakeBal;
  TextEditingController searchController = TextEditingController();
  TextEditingController zeroSearchController = TextEditingController();
  TextEditingController zeroSearchControllerFund = TextEditingController();
  TextEditingController stakingSearchController = TextEditingController();
  final WalletRepositoryImpl _walletRepositoryImpl = WalletRepositoryImpl();
  final StakingRepositoryImpl repositoryImpl = StakingRepositoryImpl();
  CurrencyNetwork currencyNetwork = CurrencyNetwork();
  String? currencySymbol ;
  List<String> categories = ['Overview', 'Fiat & Spot','Funding', 'Staking'];
  List<WalletListModal> listModal = [
    WalletListModal(image: Images.depositNew, name: 'Deposit'),
    WalletListModal(image: Images.withdrawImage, name: 'Withdraw'),
    WalletListModal(image: Images.send, name: 'Send'),
    WalletListModal(image: Images.history, name: 'History'),
  ];
  bool depositEnable = false;
  int  currentPage = 1;
  bool hasMoreData = true;
  bool isLoadingMore = false;

  @override
  onInit() {
    getStaking(Get.context!);
    getStakeBalance(Get.context!);
    getCrypto(Get.context!);
    getMarket(Get.context!);
    super.onInit();
  }

  Set<String> uniqueCurrencies = Set();
  getIndex(int i) {
    selectedCategoryIndex = i;
    update([ControllerBuilders.walletController]);
  }

  getSymbol(String symbol) {
    currencySymbol = symbol;
    update([ControllerBuilders.walletController]);
  }

  hideZeroBal() {
    hideZeroBalance = !hideZeroBalance;
    zeroFilterListFund.clear();
    zeroFilterListSpot.clear();
    zeroFilterListSpot =  search ? filterList.where((e) => double.parse(e.cBal ?? '') > 0).toList() :  walletList!.where((e) => double.parse(e.cBal ?? '') > 0).toList();
    zeroFilterListFund = search ? filterList.where((e) => double.parse(e.cBal ?? '') > 0).toList() :  walletList!.where((e) => double.parse(e.cBal ?? '') > 0).toList();
    update([ControllerBuilders.walletController]);
  }

  navigate(int i,BuildContext context) {
    currentIndex = i;
    update([ControllerBuilders.walletController]);
    if(currentIndex == 1) {
      LocalStorage.writeBool(GetXStorageConstants.withdrawFromHome, false);
      LocalStorage.writeBool(GetXStorageConstants.fromExchange, false);
      pushWithSlideTransition(context,const WithdrawList());
    }
    if(currentIndex == 0) {
      LocalStorage.writeBool(GetXStorageConstants.depositFromHome, false);
      LocalStorage.writeBool(GetXStorageConstants.fromExchange, false);
      pushWithSlideTransition(context,const DepositScreen());
    }
    if(currentIndex == 2) {
      LocalStorage.writeBool(GetXStorageConstants.transferFromHome, false);
      LocalStorage.writeBool(GetXStorageConstants.fromExchange, false);
      pushWithSlideTransition(context,const Transfer());
    } if (currentIndex == 3){
      pushWithSlideTransition(context,const HistoryPage());
    }
    update([ControllerBuilders.walletController]);
  }


  getMarket(BuildContext context) async {
        showList.clear();
        usdt.addAll([...LocalStorage.getListCrypto() ?? [] ,...LocalStorage.getListBtc() ?? [] ,...LocalStorage.getListEth() ?? [],
          ...LocalStorage.getListTbc() ?? [] , ...LocalStorage.getListTrx() ?? [] ]);
        List<Btc> chiwa = [];
        for (var i in usdt) {
          if (['BTC', 'ETH', 'WIN', 'DENT', 'XRP', 'ETC', 'DOGE', 'BNB', 'YFI', 'CAKE'].contains(i.currency)) {
            if (uniqueCurrencies.add(i.currency ?? '')) {
              chiwa.add(i);
            }
          }
        }
        showList.addAll(chiwa);
        update([ControllerBuilders.walletController]);
  }

  depositTapped() {
    deposit = true;
    withdraw = false;
    update([ControllerBuilders.walletController]);
  }

  hideButton() {
    hidePrice = !hidePrice;
    update([ControllerBuilders.walletController]);
  }

  onCopyClipBoard(BuildContext context,String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
     ToastUtils.showCustomToast(context, 'Copied Successfully', true);
    });
    update([ControllerBuilders.walletController]);
  }

  withdrawTapped() {
    deposit = false;
    withdraw = true;
    update([ControllerBuilders.walletController]);
  }

  void filterSearchZero(String text) {
    zeroSearchSpot = true;
    zeroFilterList = zeroFilterListSpot.where((e) => e.symbol!.toUpperCase().contains(text.toUpperCase())).toList();
    if(text.isEmpty) {
      zeroSearchSpot = false;
     update([ControllerBuilders.walletController]);
    }
    update([ControllerBuilders.walletController]);
  }

  void filterSearchZeroFund(String text) {
    zeroSearchFund = true;
    zeroFilterFund = zeroFilterListFund.where((e) => e.symbol!.toUpperCase().contains(text.toUpperCase())).toList();
    if(text.isEmpty) {
      zeroSearchFund = false;
      update([ControllerBuilders.walletController]);
    }
    update([ControllerBuilders.walletController]);
  }

  void filterSearch(String text) {
    search = true;
    filterList = walletList!.where((e) => e.symbol!.toUpperCase().contains(text.toUpperCase())).toList();
    if(text.isEmpty) {
      search = false;
      update([ControllerBuilders.walletController]);
    }
    update([ControllerBuilders.walletController]);
  }

  void filterSearchStaking(String text) {
    stakingSearch = true;
    filterListStaking = stakingHistorylength.where((e) => e.stakeCurrency!.toUpperCase().contains(text.toUpperCase())).toList();
    if(text.isEmpty) {
      stakingSearch = false;
      update([ControllerBuilders.walletController]);
    }
    update([ControllerBuilders.walletController]);
  }

  void onSearchTap() {
    search = false;
    searchController.clear();
    update([ControllerBuilders.walletController]);
  }

  void zeroSearch() {
   zeroSearchSpot = false;
   zeroSearchController.clear();
   update([ControllerBuilders.walletController]);
  }
   void zeroSearchFundClear() {
    zeroSearchFund = false;
   zeroSearchControllerFund.clear();
    update([ControllerBuilders.walletController]);
  }

  void onSearchStaking() {
    stakingSearch = false;
    stakingSearchController.clear();
    update([ControllerBuilders.walletController]);
  }

  onSpot() {
    spot = true;
    funding = false;
    staking = false;
    update([ControllerBuilders.walletController]);
  }

  onShareButton(String symbol) async {
    await Share.share(
        'My Public Address to receive $symbol ($networkType) - $walletAddress');
    update([ControllerBuilders.walletController]);
  }

  onFunding() {
    funding = true;
    spot = false;
    staking = false;
    update([ControllerBuilders.walletController]);
  }

  onStaking() {
    staking = true;
    spot = false;
    funding = false;
    update([ControllerBuilders.walletController]);
  }

  getStakeBalance(BuildContext context) async {
    isLoading = true;
    var data = await _walletRepositoryImpl.stakeWallet();
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
       for(var i in r.data?.data ?? []) {
         print("=============================================$i");
         print("=============================================${i.withdrawable}");
         var stakeB = double.parse(i.withdrawable);
         stakeWallet += stakeB;
       } if(stakeFirst == true) {
           stakeWalletBalance = stakeWallet.toStringAsFixed(8);
           print("================================$stakeWalletBalance");
           stakeFirst =false;
           update([ControllerBuilders.walletController]);
         }

      } else {
        isLoading = false;
        ToastUtils.showCustomToast(context, message, false);
        update([ControllerBuilders.walletController]);
      }
    });
    update([ControllerBuilders.walletController]);
  }

  getStaking(BuildContext context) async {
    if (currentPage == 1) {
      isLoading = true;
    }
    var data = await repositoryImpl.stakingHistory(currentPage);
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

  getDepositStatus(BuildContext context ,String symbol) async {
    walletLoading = true;
    var data = await _walletRepositoryImpl.wallet();
    data.fold((l) async {
      if (l is ServerFailure) {
        if(l.message == 'Unauthenticated') {
          LocalStorage.writeBool(GetXStorageConstants.userLogin, true);
          Get.offAllNamed(AppRoutes.loginScreen);
          update([ControllerBuilders.walletController]);
        }
        walletLoading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.walletController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        walletList?.clear();
        print('====================??????????????????????????${symbol}');
        walletList?.addAll(r.data ?? []);
        for(int i = 0; i< ( walletList?.length ?? 0); i++) {
          if (symbol == walletList?[i].symbol) {
            networkType = walletList?[i].currencyNetworks?[0].tokenType ?? '';
            walletAddress = walletList?[i].currencyNetworks?[0].walletAddress ?? '';
            if ((walletList?[i].currencyNetworks?[0].walletAddress?.isEmpty ?? false) || walletList?[i].currencyNetworks?[0].walletAddress == null) {
              depositEnable = false;
              update([ControllerBuilders.walletController]);
            } else {
              depositEnable = true;
              update([ControllerBuilders.walletController]);
            }
          }
        }
        walletLoading = false;
        update([ControllerBuilders.walletController]);
      } else {
        walletLoading = false;
        update([ControllerBuilders.walletController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.walletController]);
  }


  getCrypto(BuildContext context) async {
    walletLoading = true;
    var data = await _walletRepositoryImpl.wallet();
    data.fold((l) async {
      if (l is ServerFailure) {
        if(l.message == 'Unauthenticated') {
         LocalStorage.writeBool(GetXStorageConstants.userLogin, true);
         Get.offAllNamed(AppRoutes.loginScreen);
         update([ControllerBuilders.walletController]);
        }
        walletLoading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.walletController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        walletList?.clear();
        filterList.clear();
        zeroFilterListSpot.clear();
        zeroFilterListFund.clear();
        freezeBal = r.freezedTotal ?? '';
        walletList?.addAll(r.data ?? []);
        filterList.addAll(walletList ?? []);
        fcBal = r.data?[0].fcBal ?? '';
        for(int i = 0; i< ( walletList?.length ?? 0); i++) {
          var stakeB = double.parse(walletList?[i].stakeBal?? '0.0');
          var spotB = double.parse(walletList?[i].cBal?? '0.0');
          var fundB = double.parse(walletList?[i].fundBal?? '0.0');
          var stakeQ = double.parse(walletList?[i].stakeQuantity?? '0.0');
          var spotQ = double.parse(walletList?[i].quantity?? '0.0');
          var fundQ = double.parse(walletList?[i].fundQuantity?? '0.0');
          var spotFreeze = double.parse(walletList?[i].freezedBalance?? '0.0');
          var spotSpotBal = double.parse(walletList?[i].fcBal?? '0.0');
          var fundFreeze = double.parse(walletList?[i].fundFreezeBal?? '0.0');
          var fundFreezeQ = double.parse(walletList?[i].fundFreezeQ?? '0.0');
          dstakeBalance += stakeB;
          dspotBalance += spotB;
          dfundBalance += fundB;
          dstakeqty += stakeQ;
          dspotqty += spotQ;
          dfundqty += fundQ;
          freezeFund += spotFreeze;
          freezeSpotQ += spotSpotBal;
          fundFreezeB += fundFreeze;
          fundFreezeQun += fundFreezeQ;
          total = dspotBalance + dstakeBalance + dfundBalance;
          totalQty = dspotqty + dfundqty + dstakeqty;
        }
        if( firstTimeData == true) {
          stakeBalance = dstakeBalance.toString();
          spotBalance = dspotBalance.toString();
          fundBalance = dfundBalance.toString();
          stakeQuantity = dstakeqty.toString();
          spotQuantity = dspotqty.toString();
          fundQuant = dfundqty.toString();
          totalBal =total.toString();
          allQty = totalQty.toString();
          freezeSpotBal = freezeFund.toString();
          freezeSpotQuantity = freezeSpotQ.toString();
          freezeFundPrice = fundFreezeB.toStringAsFixed(2);
          freezeSpotQuantity = fundFreezeQun.toStringAsFixed(2);
          print("========+++++++++++++++++++++++++++++++++++++$totalBal");
          isLoading = false;
          firstTimeData =false;
        }
        zeroFilterListSpot =  search ? filterList.where((e) => double.parse(e.cBal ?? '') > 0).toList() :  walletList!.where((e) => double.parse(e.cBal ?? '') > 0).toList();
        zeroFilterListFund =  search ? filterList.where((e) => double.parse(e.cBal ?? '') > 0).toList() :  walletList!.where((e) => double.parse(e.cBal ?? '') > 0).toList();
        walletLoading = false;
        update([ControllerBuilders.walletController]);
      } else {
        walletLoading = false;
        update([ControllerBuilders.walletController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.walletController]);
  }

  getDeposit(BuildContext context) async {
    isLoading = true;
    var data = await _walletRepositoryImpl.deposit();
    data.fold((l) {
      if (l is ServerFailure) {
        if(l.message == 'Unauthenticated') {
          LocalStorage.writeBool(GetXStorageConstants.userLogin, true);
          Get.offAllNamed(AppRoutes.loginScreen);
          update([ControllerBuilders.walletController]);
        }
        isLoading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
      } else {
        isLoading = false;
        ToastUtils.showCustomToast(context, message, false);
      }
    });
  }

  createWallet(BuildContext context,String currencyId,String networkId,String symbol) async {
    walletGenerate = true;
    update([ControllerBuilders.walletController]);
    var req = WalletCreateRequest(currencyId: currencyId, networkId: networkId, tokenType: networkType ?? '');
    var data = await _walletRepositoryImpl.walletCreate(req);
    data.fold((l) {
      if (l is ServerFailure) {
        walletGenerate = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.walletController]);
      }
    }, (r) async {
      if(r.statusCode == '1') {
        walletGenerate = false;
        await getDepositStatus(context,symbol);
        ToastUtils.showCustomToast(context, r.message ?? '', true);
        update([ControllerBuilders.walletController]);
      }else {
        walletGenerate = false;
        ToastUtils.showCustomToast(context, r.message ?? '', false);
        update([ControllerBuilders.walletController]);
      }

    });
    update([ControllerBuilders.walletController]);
  }


  void showCupertinoSheet(BuildContext context,List <CurrencyNetwork>? network) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: buildSheetActions(context,network),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child:  TradeBitTextWidget(title: 'Cancel',style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor),),
          ),
        );
      },
    );
    update([ControllerBuilders.walletController]);
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


  List<Widget> buildSheetActions(BuildContext context,List <CurrencyNetwork>? network) {
    return network!.map((item) {
      return item.depositEnable == false ? const SizedBox.shrink(): CupertinoActionSheetAction(
        onPressed: () {
          String? network = getSelf(item.tokenType.toString());
          networkType = network ?? '';
          firstTime = false;
          walletAddress = item.walletAddress;
          update([ControllerBuilders.walletController]);
          Get.back();
        },
        child: Row(
          children: [
            HorizontalSpacing(width: Dimensions.w_15),
            TradeBitTextWidget(title: getSelf(item.tokenType ?? ''), style: AppTextStyle.normalTextStyle(FontSize.sp_15, Theme.of(context).highlightColor))
          ],
        ),
      );
    }).toList();
  }

  void showBottomSheetDeposit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                       GestureDetector(
                         onTap: () {
                           pushReplacementWithSlideTransition(context, DashBoard(index: 2));
                         },
                         child: TradeBitContainer(
                           padding: EdgeInsets.only(left: Dimensions.w_20),
                           height: Dimensions.h_40,
                           width: double.infinity,
                           decoration: BoxDecoration(
                             color: Theme.of(context).scaffoldBackgroundColor,
                             borderRadius: BorderRadius.circular(8)
                           ),
                           child: Align(
                             alignment: Alignment.centerLeft,
                             child: TradeBitTextWidget(title: 'Trade',style: AppTextStyle.themeBoldNormalTextStyle(
                               fontSize: FontSize.sp_16,
                               color: Theme.of(context).highlightColor
                             ),),
                           ),
                         ),
                       ),
                        VerticalSpacing(height: Dimensions.h_5),
                        TradeBitContainer(
                          padding: EdgeInsets.only(left: Dimensions.w_20),
                          height: Dimensions.h_40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TradeBitTextWidget(title: 'Debit/Credit (coming soon)',style: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_16,
                                color: Theme.of(context).highlightColor
                            ),),
                          ),
                        ),
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

}

