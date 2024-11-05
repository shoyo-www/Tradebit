import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Auth/login/login.dart';
import 'package:tradebit_app/Presentation/exchange/exhange_controller.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/home_repository.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/frees_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/logout_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/activity_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/banner_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/gainers_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/profile_response.dart';
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../data/datasource/remote/models/response/crypto_response.dart';

class HomeController extends GetxController {
  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  List<CoreDatum> gainers = [];
  List<CoreDatum> losers = [];
  List<CoreDatum> hotDeals = [];
  ProfileData? profile;
  bool isLoading = false;
  bool cryptoLoading = false;
  bool pageButton = false;
  bool feesButton = false;
  bool isProfile = true;
  bool isSecurity = false;
  bool activity = false;
  bool loadData = false;
  List<ActivityData> activityList = [];
  List<String> tickers = [];
  final HomeRepositoryImpl _homeRepository = HomeRepositoryImpl();
  ExchangeController exchangeController = ExchangeController();
  List<String> bannerImage = [
    'assets/images/Frame 39558.png',
    'assets/images/Frame 39559.png',
    'assets/images/Frame 39560.png'
  ];
  int page = 1;

  @override
  void onInit() async {
    super.onInit();
    await getGainers(Get.context!);
    connectToSocket();
    LocalStorage.getBool(GetXStorageConstants.userLogin) == false ? getProfileData(Get.context!) : null;
  }

  profileButton () {
    isProfile = true;
    isSecurity = false;
    activity = false;
    update([ControllerBuilders.homeController]);
  }

  securityButton() {
    isProfile = false;
    isSecurity = true;
    activity = false;
    update([ControllerBuilders.homeController]);
  }

  activityButton() {
    isProfile = false;
    isSecurity = false;
    activity = true;
    update([ControllerBuilders.homeController]);
  }

  void onTapped(int index) {
    currentIndex = index;
    pageController.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    pageButton = true;
    update([ControllerBuilders.homeController]);
  }

  void onTappedBack(int index) {
    pageButton = false;
    currentIndex = index;
    pageController.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    update([ControllerBuilders.homeController]);
  }

  getActivity(BuildContext context) async {
    isLoading = true;
    update([ControllerBuilders.homeController]);
    var data = await _homeRepository.getActivity( page);
    data.fold((l) {
      if (l is ServerFailure) {
        isLoading = false;
        update([ControllerBuilders.homeController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if (code == '1') {
        isLoading = false;
        if (page == 1) {
          activityList.clear();
        }
        activityList.addAll(r.data?.data ?? []);
        update([ControllerBuilders.homeController]);
        if (r.data?.nextPageUrl != null) {
          page++;
        } else {}
      } else {
        isLoading = false;
        update([ControllerBuilders.homeController]);
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.homeController]);
  }

  loadMoreActivities(BuildContext context) async {
    if (page > 1) {
      loadData = true;
      update([ControllerBuilders.homeController]);
      await getActivity(context);
      loadData = false;
      update([ControllerBuilders.homeController]);
    }
  }

  onFees(bool v,BuildContext context) async{
    isLoading = true;
    feesButton = v;
    final req = FeesRequest(feeByLbm: v == true ? 1 : 0);
    var data = await _homeRepository.fees(req);
    data.fold((l) {
      if(l is ServerFailure) {
        isLoading = false;
        update([ControllerBuilders.homeController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        isLoading = false;
        ToastUtils.showCustomToast(context, r.message ?? '', true);
        update([ControllerBuilders.homeController]);
      }
      else {
        isLoading = false;
        update([ControllerBuilders.homeController]);
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.homeController]);
  }


  logoutFromSingle(BuildContext context) async {
       isLoading = true;
       update([ControllerBuilders.homeController]);
       final req = LogoutRequest(email: LocalStorage.getString(GetXStorageConstants.userEmail));
       var data = await _homeRepository.logoutFromSingle(req);
       data.fold((l) {
         if(l is ServerFailure) {
           isLoading = false;
           update([ControllerBuilders.homeController]);
           ToastUtils.showCustomToast(context, l.message ?? '', false);
         }
       }, (r)  {
         String code = r.statusCode ?? '';
         if(code == '1' ) {
           ToastUtils.showCustomToast(context, r.message ?? '', true);
           LocalStorage.writeBool(GetXStorageConstants.userLogin, true);
           LocalStorage.clearValueByKey(GetXStorageConstants.authToken);
           LocalStorage.clearValueByKey(GetXStorageConstants.kyc);
           isLoading = false;
           update([ControllerBuilders.homeController]);
           Get.offAllNamed(AppRoutes.loginScreen);
         }
         else {
           isLoading = false;
           update([ControllerBuilders.homeController]);
           ToastUtils.showCustomToast(context, r.message ?? '', false);
         }
       });
     }

     logoutFromAll(BuildContext context) async {
       isLoading = true;
       update([ControllerBuilders.homeController]);
       final req = LogoutRequest(email: LocalStorage.getString(GetXStorageConstants.userEmail));
       var data = await _homeRepository.logoutFromAll(req);
       data.fold((l) {
         if(l is ServerFailure) {
           isLoading = false;
           update([ControllerBuilders.homeController]);
           ToastUtils.showCustomToast(context, l.message ?? '', false);
         }
       }, (r) {
         String code = r.statusCode ?? '';
         if(code == '1' ) {
           ToastUtils.showCustomToast(context, r.message ?? '', true);
           LocalStorage.writeBool(GetXStorageConstants.userLogin, true);
           LocalStorage.clearValueByKey(GetXStorageConstants.authToken);
           LocalStorage.clearValueByKey(GetXStorageConstants.kyc);
           isLoading = false;
           update([ControllerBuilders.homeController]);
           Get.offAllNamed(AppRoutes.loginScreen);
         }
         else {
           isLoading = false;
           update([ControllerBuilders.homeController]);
           ToastUtils.showCustomToast(context, r.message ?? '', false);
         }
       });
     }

     void showCupertinoDialogWithButtons(BuildContext context) {
       showDialog(
         context: context,
         builder: (BuildContext context) {
           return CupertinoAlertDialog(
             title:  Text('Logout',style: AppTextStyle.themeBoldTextStyle(
               fontSize: FontSize.sp_12,
               color: Theme.of(context).highlightColor
             ),),
             actions: [
               CupertinoDialogAction(
                 child:  Text('Logout from this device',style: AppTextStyle.themeBoldNormalTextStyle(
                   fontSize: FontSize.sp_13,
                   color: Theme.of(context).highlightColor
                 ),),
                 onPressed: () {
                    logoutFromSingle(context);
                 },
               ),
                CupertinoDialogAction(
                 child:  Text('Logout from all devices',style: AppTextStyle.themeBoldNormalTextStyle(
                     fontSize: FontSize.sp_13,
                     color: Theme.of(context).highlightColor
                 )),
                 onPressed: () {
                    logoutFromAll(context);
                 },
               ),
             ],
           );
         },
       );
       update([ControllerBuilders.homeController]);
     }



  getProfileData(BuildContext context) async{
    isLoading = true;
    var data = await _homeRepository.profile();
    data.fold((l) {
      if (l is ServerFailure) {
        if(LocalStorage.getBool(GetXStorageConstants.userLogin) == true) {
          if(l.message == 'Unauthenticated') {
            LocalStorage.writeBool(GetXStorageConstants.userLogin, true);
            Get.offAllNamed(AppRoutes.loginScreen);
          }
        }
        isLoading = false;
        update([ControllerBuilders.homeController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        profile = r.data;
        isLoading = false;
        LocalStorage.writeString(GetXStorageConstants.userEmail, r.data?.email ?? '');
        LocalStorage.writeString(GetXStorageConstants.userKycStatus, r.data?.userKycStatus ?? '');
        LocalStorage.writeString(GetXStorageConstants.userMobile, r.data?.mobile ?? '');
        LocalStorage.writeBool(GetXStorageConstants.emailVcode, r.data?.emailOtp == 0 ? false : true);
        LocalStorage.writeBool(GetXStorageConstants.mobileVcode, r.data?.smsOtp == 0 ? false : true);
        LocalStorage.writeBool(GetXStorageConstants.googleVcode, r.data?.google2Fa == 0 ? false : true);
        if(r.data?.profileStatus == 'new') {
          LocalStorage.writeBool(GetXStorageConstants.basic, true);
        } else{}
      } else {
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.homeController]);
  }

  StreamController<String> streamController = StreamController.broadcast();
  WebSocketChannel? _webSocketChannel;
  StreamController<String> streamControllerGainer = StreamController.broadcast();
  WebSocketChannel? _webSocketChannelGainer;
  StreamController<String> streamControllerLooser = StreamController.broadcast();
  WebSocketChannel? _webSocketChannelLooser;

     getGainers(BuildContext context) async{
       isLoading = true;
       var data = await _homeRepository.gainers();
       data.fold((l) {
         if (l is ServerFailure) {
           isLoading = false;
           update([ControllerBuilders.homeController]);
           ToastUtils.showCustomToast(context, l.message ?? '', false);
         }
       }, (r) {
         String code = r.statusCode ?? '';
         String message = r.message ?? '';
         if (code == '1') {
           gainers.clear();
           losers.clear();
           gainers.addAll(r.data?.gainers ?? []);
           losers.addAll(r.data?.losers ?? []);
           hotDeals.addAll(r.data?.coreData ?? []);
           tickers.addAll(r.data?.tickers ?? []);
           isLoading = false;
         } else {
           isLoading = false;
           ToastUtils.showCustomToast(context, message, false);
         }
       });
       update([ControllerBuilders.homeController]);
     }


  void connectToSocket() {
    var subscribeMessage = json.encode({
      'method': "SUBSCRIBE",
      'params': [for (var i in tickers) i.toLowerCase()],
      'id': 1,
    });

    _webSocketChannel = IOWebSocketChannel.connect(Apis.binanceSocket);

    _webSocketChannel?.stream.listen((data) {
      streamController.add(data);
    });

    _webSocketChannel?.sink.add(subscribeMessage);
  }


  connectToSocketGainers() async {
    var subscribeMessage = json.encode({
      'method': "SUBSCRIBE",
      'params': [for (var i in gainers) "${i.symbol?.toLowerCase()}@ticker"],
      'id': 1,
    });

    _webSocketChannelGainer = IOWebSocketChannel.connect(Apis.binanceSocket);

    _webSocketChannelGainer?.stream.listen((data) {
      streamControllerGainer.add(data);
    });

    _webSocketChannelGainer?.sink.add(subscribeMessage);
  }

  connectToSocketLosers() async {
    var subscribeMessage = json.encode({
      'method': "SUBSCRIBE",
      'params': [for (var i in losers) "${i.symbol?.toLowerCase()}@ticker"],
      'id': 1,
    });

    _webSocketChannelLooser = IOWebSocketChannel.connect(Apis.binanceSocket);

    _webSocketChannelLooser?.stream.listen((data) {
      streamControllerLooser.add(data);
    });

    _webSocketChannelLooser?.sink.add(subscribeMessage);
     }

}