import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tradebit_app/Presentation/Wallet/wallet_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/transfer/transfer.dart';
import 'package:tradebit_app/Presentation/transfer/transfer_verfication.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/wallet_repositoryImpl.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/transfer_otp_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/transfer_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/transfer_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/walletListResponse.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class TransferController extends GetxController {
  bool spot = true;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool funding = false;
  bool email = true;
  bool mobile = false;
  bool uid = false;
  bool loading = false;
  String recipient = 'Email';
  String type = 'Email';
  String walletType = 'spot';
  String? image;
  String? symbol;
  String? spotAmount;
  String? fundAmount;
  String? userEmail;
  String? userMobile;
  bool? google2fa;
  bool? emailEnable;
  bool? mobileEnable;
  String? validation;
  bool isTimerEnabled = false;
  bool isTimerMobileEnabled = false;
  int endTime = 0;
  int mobileEnd = 0;
  final List<Datum>? walletList = [];
  final WalletRepositoryImpl _walletRepositoryImpl = WalletRepositoryImpl();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController uidController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController emailOtpController = TextEditingController();
  final TextEditingController mobileOtpController = TextEditingController();
  final TextEditingController googleOtpController = TextEditingController();
  final WalletController walletController = WalletController();
  final _formKey = GlobalKey<FormState>();
  bool mobileLoading = false;
  bool emailLoading  = false;


 getList(List<VerifyCheckList>? verify) {
   for (var i in verify ?? []) {
     if(i.type == "email") {
       emailEnable = true;
     }
     else if(i.type == 'google') {
       google2fa = true;
     }
     else if(i.type == 'mobile'){
       mobileEnable = true;
     }

   }
   update([ControllerBuilders.transferController]);
 }

getBack(BuildContext context) {
   isTimerEnabled = false;
   isTimerMobileEnabled = false;
   emailOtpController.clear();
   mobileOtpController.clear();
   googleOtpController.clear();
   amountController.clear();
   emailController.clear();
   Navigator.pop(context);
   update([ControllerBuilders.transferController]);
}
  getCrypto(BuildContext context) async {
    var data = await _walletRepositoryImpl.wallet();
    data.fold((l) {
      if (l is ServerFailure) {
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        walletList?.clear();
        walletList?.addAll(r.data ?? []);
        image = r.data?[0].image ?? '';
        symbol = r.data?[0].symbol ?? '';
        spotAmount = r.data?[0].quantity ?? '';
        fundAmount = r.data?[0].fundQuantity ?? '';
        update([ControllerBuilders.transferController]);
      } else {
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.transferController]);
  }

  onSpot() {
    spot = true;
    funding = false;
    walletType = 'spot';
    update([ControllerBuilders.transferController]);
  }

  onFunding() {
    spot = false;
    funding = true;
    walletType = 'fund';
    update([ControllerBuilders.transferController]);
  }

  onEmail() {
    email = true;
    mobile = false;
    uid = false;
    recipient = 'Email';
    type = 'Email';
    key.currentState?.reset();
    update([ControllerBuilders.transferController]);
  }

  onMobile() {
    email = false;
    mobile = true;
    uid = false;
    recipient = 'Mobile';
    type = 'Mobile';
    key.currentState?.reset();
    update([ControllerBuilders.transferController]);
  }

  onUid() {
    email = false;
    mobile = false;
    uid = true;
    recipient = 'UID';
    key.currentState?.reset();
    update([ControllerBuilders.transferController]);
  }

  onMax() {
    amountController.text = spot == true ? spotAmount ?? '' : fundAmount ?? '';
    update([ControllerBuilders.transferController]);
}

  validateAmount(String? value) {
    if (value == null || value.isEmpty) {
       validation = 'Enter Amount';
    }
    validation =  '';
    update([ControllerBuilders.transferController]);
  }

  void showCupertinoSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: CupertinoActionSheet(
            actions: _buildSheetActions(context),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child:  TradeBitTextWidget(title: 'Cancel', style: AppTextStyle.normalTextStyle(FontSize.sp_18, Theme.of(context).highlightColor)),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSheetActions(BuildContext context) {
    return walletList!.map((item) {
      return CupertinoActionSheetAction(
        onPressed: () {
          image = item.image ?? '';
          symbol = item.symbol ?? '';
          spotAmount =  item.quantity ?? '0.0';
          fundAmount = item.fundQuantity ?? '0.0';
          Get.back();
          update([ControllerBuilders.transferController]);
        },
        child: Row(
          children: [
            SizedBox(
              height: Dimensions.h_30,
                width: Dimensions.h_30,
                child: Image.network(item.image ?? '')),
            HorizontalSpacing(width: Dimensions.w_15),
            TradeBitTextWidget(title: item.symbol ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_15, Theme.of(context).highlightColor))
          ],
        ),
      );
    }).toList();
  }

  transfer(BuildContext context ) async {
    if (key.currentState!.validate()) {
      if (amountController.text.isEmpty) {
        ToastUtils.showCustomToast(context, 'Please enter amount', false);
        return;
      }
      double enteredAmount = double.parse(amountController.text);
      double availableAmount = spot ? double.parse(spotAmount ?? '0.0') : double.parse(fundAmount ?? '0.0');
      if (enteredAmount > availableAmount) {
        ToastUtils.showCustomToast(context, 'Not enough balance', false);
        return;
      }
      loading = true;
      update([ControllerBuilders.transferController]);
      var request = TransferRequest(
        currency: symbol,
        amount: amountController.text,
        emailVcode: emailOtpController.text,
        googleVcode: googleOtpController.text,
        mobileVcode: mobileController.text,
        type: recipient,
        user: (email == true) ? emailController.text : (mobile == true) ? mobileController.text : uidController.text,
        walletType: walletType,
      );
      var data = await _walletRepositoryImpl.transfer(request);
      data.fold(
              (l) {
            if (l is ServerFailure) {
              loading = false;
              update([ControllerBuilders.transferController]);
              ToastUtils.showCustomToast(context, l.message ?? '', false);
            }
          },(r) {
            String message = r.message ?? '';
            String code = r.statusCode ?? '';
            if (code == '1') {
              loading = false;
              update([ControllerBuilders.transferController]);
              ToastUtils.showCustomToast(context, message, true);
              pushWithSlideTransition(context, TransferVerification(
                amount: r.data?.amount ?? '',
                paymentMethod: r.data?.walletType ?? '',
                email: r.data?.verifyCheckList?[0].type ?? '',
                verify: r.data?.verifyCheckList ?? [],
                currency: r.data?.currency ?? '',
                receiver: r.data?.user ?? '',
              ));
            }
            else {
              loading = false;
              update([ControllerBuilders.transferController]);
              ToastUtils.showCustomToast(context, message, false);
            }
          });
        }
    update([ControllerBuilders.transferController]);
  }

  void startTimer() {
    endTime = DateTime.now().millisecondsSinceEpoch + 120000;
  }

  void startTimerMobile() {
    mobileEnd = DateTime.now().millisecondsSinceEpoch + 120000;
  }

 onGetCode(BuildContext context) async{
   emailLoading = true;
   update([ControllerBuilders.transferController]);
   var request = TransferOtpRequest(
     type: 'email'
   );
   var data = await _walletRepositoryImpl.transferOtp(request);
   data.fold((l) {
     if (l is ServerFailure) {
       emailLoading = false;
       update([ControllerBuilders.transferController]);
       ToastUtils.showCustomToast(context, l.message ?? '', false);
     }
   }, (r) {
     String message = r.message ?? '';
     String code = r.statusCode ?? '';
     if (code == '1') {
       isTimerEnabled = true;
       startTimer();
       userEmail = r.data?.email ?? '';
       userMobile = r.data?.mobile ?? '';
       emailLoading = false;
       update([ControllerBuilders.transferController]);
       ToastUtils.showCustomToast(context, message, true);
     }
     else {
       emailLoading = false;
       update([ControllerBuilders.transferController]);
       ToastUtils.showCustomToast(context, message, false);
     }
   });
 }

  onMobileGetCode(BuildContext context) async{
    mobileLoading = true;
    update([ControllerBuilders.transferController]);
    var request = TransferOtpRequest(
        type: 'mobile'
    );
    var data = await _walletRepositoryImpl.transferMobile(request);
    data.fold((l) {
      if (l is ServerFailure) {
        mobileLoading = false;
        update([ControllerBuilders.transferController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String message = r.message ?? '';
      String code = r.statusCode ?? '';
      if (code == '1') {
        isTimerMobileEnabled = true;
        startTimerMobile();
        userEmail = r.data?.email ?? '';
        userMobile = r.data?.mobile ?? '';
        mobileLoading = false;
        update([ControllerBuilders.transferController]);
        ToastUtils.showCustomToast(context, message, true);
      }
      else {
        mobileLoading = false;
        update([ControllerBuilders.transferController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
  }

  transferVerification(BuildContext context ) async {
   if(emailOtpController.text.isEmpty && googleOtpController.text.isEmpty && mobileController.text.isEmpty) {
     ToastUtils.showCustomToast(context, 'Please enter OTP', false);
   } else {
     loading = true;
     update([ControllerBuilders.transferController]);
     var request = TransferRequest(
         currency: symbol,
         amount: amountController.text,
         emailVcode: emailOtpController.text,
         googleVcode: googleOtpController.text,
         mobileVcode: mobileOtpController.text,
         type: type,
         user: (email == true) ? emailController.text : (mobile == true) ? mobileController.text : uidController.text,
         walletType: walletType
     );
     var data = await _walletRepositoryImpl.transferReceiver(request);
     data.fold((l) {
       if (l is ServerFailure) {
         loading = false;
         update([ControllerBuilders.transferController]);
         ToastUtils.showCustomToast(context, l.message ?? '', false);
       }
     }, (r) {
       String message = r.message ?? '';
       String code = r.statusCode ?? '';
       if (code == '1') {
         loading = false;
         amountController.clear();
         update([ControllerBuilders.transferController]);
         ToastUtils.showCustomToast(context, message, true);
         Navigator.push(context, MaterialPageRoute(builder: (context)=> const Transfer()));
       }
       else {
         loading = false;
         update([ControllerBuilders.transferController]);
         ToastUtils.showCustomToast(context, message, false);
       }
     });
   }

  }
  showSheet (BuildContext context) {
    return showModalBottomSheet
      (backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.80,
              maxChildSize: 0.80,
              minChildSize: 0.80,
              expand: true,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)
                      )
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VerticalSpacing(height: Dimensions.h_40),
                          Center(
                            child: TradeBitTextWidget(
                                title: 'Authenticate',
                                style: AppTextStyle.themeBoldTextStyle(
                                    fontSize: FontSize.sp_22,
                                    color: Theme.of(context).canvasColor
                                )
                            ),
                          ),
                          VerticalSpacing(height: Dimensions.h_40),
                          Padding(
                            padding: EdgeInsets.only(left:Dimensions.w_30),
                            child: TradeBitTextWidget(
                              title: "Google authenticator",
                              style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          VerticalSpacing(height: Dimensions.h_15),
                          Container(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PinCodeTextField(
                                    validator: Validator.otpValidate,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    autoFocus: false,
                                    length: 6,
                                    obscureText: false,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      borderWidth: 1,
                                      selectedColor: AppColor.appcolor,
                                      selectedFillColor: Colors.white,
                                      inactiveColor: AppColor.neutral_400,
                                      activeColor: AppColor.appcolor,
                                      activeFillColor: Colors.white,
                                      inactiveFillColor: Colors.white,
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(10),
                                      fieldHeight: Dimensions.h_50,
                                      fieldWidth: Dimensions.w_50,
                                    ),
                                    animationDuration: const Duration(milliseconds: 300),
                                    controller: googleOtpController,
                                    enableActiveFill: true,
                                    onCompleted: (v) {},
                                    onChanged: (value) {},
                                    appContext: context,
                                  ),
                                  VerticalSpacing(height: Dimensions.h_10),
                                  Padding(
                                    padding: EdgeInsets.only(left: Dimensions.w_30),
                                    child: TradeBitTextWidget(title: "Enter 6 digit code received on google authenticator", style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                  ),
                                  VerticalSpacing(height: Dimensions.h_30),
                                  Container(
                                    margin: EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if(_formKey.currentState!.validate()) {
                                          transferVerification(context);
                                        }
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(Colors.white),
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(AppColor.appColor),
                                        shape:
                                        MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      child:  const Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: Text(
                                          'SUBMIT',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          VerticalSpacing(height: Dimensions.h_15),
                        ],
                      ),
                      Positioned(
                          right: 15,
                          top: 25
                          ,child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        }
                        ,child: TradeBitContainer(
                        decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        height: Dimensions.h_22,
                        width: Dimensions.h_22,
                        child: const Center(child: Icon(Icons.close,size: 18,)),
                      ),
                      ))
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}