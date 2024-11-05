
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/home_repository.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/banner_response.dart';

class Constants {
  static const responseError = 'ERROR';
  static const responseSuccess = 'SUCCESS';
  static const someThingWentWrong = 'Something went wrong.';
  static const reCaptchaSiteKey = '6LdpybgmAAAAAISLIzZ5Orj6922divJgT3_EeYJh';
}

class GetXStorageConstants {
  static const authToken = "Authorization";
  static const darkTheme = "DarkTheme";
  static const profileStatus = "ProfileStatus";
  static const userEmail = 'UserEmail';
  static const userMobile = 'UserMobile';
  static const userProfile = 'userProfile';
  static const userKycStatus = 'userKycStatus';
  static const userName = 'userName';
  static const user = 'user';
  static const userid = 'userid';
  static const onBoarding = 'onBoarding';
  static const isLogin = 'isLogin';
  static const userLogin = 'userLogin';
  static const day = 'day';
  static const loginFromHome = 'loginFromHome';
  static const stakingDeposit = 'stakingDeposit';
  static const searchFromHome = 'searchFromHome';
  static const withdrawFromHome = 'withdrawFromHome';
  static const depositFromHome = 'depositFromHome';
  static const transferFromHome = 'transferFromHome';
  static const exchangeFromHome = 'exchangeFromHome';
  static const mobileVcode = 'mobileVcode';
  static const googleVcode = 'googleVcode';
  static const emailVcode = 'emailVcode';
  static const kyc = 'kyc';
  static const basic = 'basic';
  static const basicFirst = 'basicFirst';
  static const depositEnable = 'depositEnable';
  static const fromExchange = 'fromExchange';
  static const fromCoin = 'fromCoin';
  static const bidsPrice = 'bidsPrice';
  static const banner = 'banner';
  static const cryptoList = 'cryptoList';
  static const cryptoBtc = 'cryptoBtc';
  static const cryptoEth = 'cryptoEth';
  static const cryptoTbc = 'cryptoTbc';
  static const cryptoTrx = 'cryptoTrx';
  static const tickers = 'tickers';
  static const listedTickers = 'listedTickers';
  static const symbol = 'symbol';
  static const price = 'price';
  static const pair = 'pair';
  static const name = 'name';
  static const firstTime = 'firstTime';
  static const fromAnother = 'fromAnother';
  static const change = 'change';
  static const listed = 'listed';
}

class ControllerBuilders {
  static String loginPageController = 'LoginPageController';
  static String otpPageController = 'OtpPageController';
  static String registerController = 'RegisterController';
  static String forgotController = 'ForgotController';
  static String homeController = 'HomeController';
  static String walletController = 'walletController';
  static String refferalController = 'refferalController';
  static String onBoardingController = 'onBoardingController';
  static String exchangeController = 'exchangeController';
  static String exchangeControllerDrawer = 'exchangeControllerDrawer';
  static String marketController = 'marketController';
  static String withdrawController = 'withdrawController';
  static String depositController = 'depositController';
  static String depositWithdrawController = 'depositWithdrawController';
  static String transferController = 'transferController';
  static String historyController = 'historyController';
  static String notificationController = 'notificationController';
  static String stakingController = 'stakingController';
  static String kycController = 'kycController';
  static String changePasswordController = 'changePasswordController';
  static String securityController = 'securityController';
  static String sendTokenController = 'sendTokenController';
  static String dashboardController = 'dashboardController';
  static String ticketController = 'ticketController';
  static String datePicker = 'datePicker';
  static String basicController = 'basicController';
  static String button = 'button';


}

class ApiStatus {
  static const success = "1";
  static const failed = "Failed";
}

class FontFamily {
  static const poppins = 'Poppins';
}

class MenuItem {
  final String name;
  final String image;
  
  MenuItem({required this.name,required this.image});
}

class DateFormats {
  static String yyyyMMddWithDash = 'YYYY-MM-dd';
  static String ddMMMWithSpace = 'dd MMM';
  static String eeeDdMMMyyyy = 'EEEE dd MMM yyyy';
  static String ddMMMyyyy = 'dd MMM yyyy';
  static String eDDMMM = 'E, dd MMM';
  static String hhmma = 'hh:mm a';
  static String month = 'MMMM';
  static String eeeee = 'EEEEE';
}


class BannerController extends GetxController {

}

class BannerImage {
  List<Banners> bannerList = [];
  final HomeRepositoryImpl _homeRepository = HomeRepositoryImpl();

  getBanners() async{
    var data = await _homeRepository.banner();
    data.fold((l) {
      if (l is ServerFailure) {
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if (code == '1') {
        bannerList.clear();
        bannerList.addAll(r.data ?? []);
        LocalStorage.saveList(r.data ?? []);
        print('data added');
      } else {}
    });
  }

  getCrypto() async{
    var data = await _homeRepository.crypto();
    data.fold((l) {
      if (l is ServerFailure) {}
    }, (r) async {
      String code = r.statusCode ?? '';
      if (code == '1') {
        LocalStorage.clearValueByKey(GetXStorageConstants.cryptoList);
        LocalStorage.clearValueByKey(GetXStorageConstants.cryptoBtc);
        LocalStorage.clearValueByKey(GetXStorageConstants.cryptoEth);
        LocalStorage.clearValueByKey(GetXStorageConstants.cryptoTbc);
        LocalStorage.clearValueByKey(GetXStorageConstants.cryptoTrx);
        LocalStorage.clearValueByKey(GetXStorageConstants.tickers);
        LocalStorage.clearValueByKey(GetXStorageConstants.listedTickers);
        LocalStorage.saveListCrypto(r.data?.usdt ?? []);
        LocalStorage.saveListBtc(r.data?.btc ?? []);
        LocalStorage.saveListEth(r.data?.eth ?? []);
        LocalStorage.saveListTbc(r.data?.tbc ?? []);
        LocalStorage.saveListTrx(r.data?.trx ?? []);
        LocalStorage.saveListTickers(r.tickers ?? [],GetXStorageConstants.tickers);
        LocalStorage.saveListTickers(["MCOINUSDT","TBCUSDT","MCOINTBC"],GetXStorageConstants.listedTickers);
      } else {}
    });
  }
}