import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/transfer/transfer.dart';
import 'package:tradebit_app/Presentation/transfer/transfer_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/transfer_response.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';

class TransferVerification extends StatefulWidget {
  final String? amount;
  final String? paymentMethod;
  final String? email;
  final List<VerifyCheckList>? verify;
  final String? currency;
  final String? fee;
  final String? receiver;
  const TransferVerification({super.key,  this.amount,  this.paymentMethod, this.receiver, this.email,this.verify,this.currency,this.fee});

  @override
  State<TransferVerification> createState() => _TransferVerificationState();
}

class _TransferVerificationState extends State<TransferVerification> {
  final TransferController controller = Get.put(TransferController());

  @override
  void initState() {
    Future.delayed(Duration.zero,() async {
      controller.getList(widget.verify);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      init: controller,
      id: ControllerBuilders.transferController,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {

            return false;
          },
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: TradeBitScaffold(
             appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: 'Confirmation',onTap: ()=> controller.getBack(context))),
                  body: SingleChildScrollView(
                    child: Column(
                        children: [
                          TradeBitContainer(
                            padding: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15,top: Dimensions.h_20,bottom: Dimensions.h_20),
                            margin: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20,top: Dimensions.h_30),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TradeBitTextWidget(title: 'Amount', style: AppTextStyle.normalTextStyle( FontSize.sp_14, Theme.of(context).highlightColor)),
                                    TradeBitTextWidget(title: '${widget.amount} ${widget.currency}', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_13,color: Theme.of(context).shadowColor))
                                  ],
                                ),
                                VerticalSpacing(height: Dimensions.h_10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TradeBitTextWidget(title: 'Payment Method', style: AppTextStyle.normalTextStyle( FontSize.sp_14, Theme.of(context).highlightColor)),
                                    TradeBitTextWidget(title: '${widget.paymentMethod?.toUpperCase()}', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:  FontSize.sp_14,color:  Theme.of(context).shadowColor))
                                  ],
                                ),
                                VerticalSpacing(height: Dimensions.h_10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TradeBitTextWidget(title: 'Total', style: AppTextStyle.normalTextStyle( FontSize.sp_14,Theme.of(context).highlightColor)),
                                    TradeBitTextWidget(title: '${widget.amount}', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_16,color: AppColor.appColor))
                                  ],
                                ),
                                VerticalSpacing(height: Dimensions.h_10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TradeBitTextWidget(title: 'Receiver', style: AppTextStyle.normalTextStyle( FontSize.sp_14, Theme.of(context).highlightColor)),
                                    TradeBitTextWidget(title: '${widget.receiver}', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color:  AppColor.appColor))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          TradeBitContainer(
                            padding: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15,top: Dimensions.h_20,bottom: Dimensions.h_20),
                            margin: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20,top: Dimensions.h_30),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TradeBitTextWidget(title: 'Security Verification', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_20,color: Theme.of(context).highlightColor)),
                                VerticalSpacing(height: Dimensions.h_5),
                                TradeBitTextWidget(title: 'We recommend to not disable security that\n you have enabled', style: AppTextStyle.normalTextStyle( FontSize.sp_12, Theme.of(context).shadowColor)),
                                VerticalSpacing(height: Dimensions.h_25),
                                Visibility(
                                  visible: controller.emailEnable ?? false,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TradeBitTextWidget(title: 'Email Verification Code', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor)),
                                          GestureDetector(
                                              onTap: () {
                                                controller.onGetCode(context);
                                              },
                                              child:  controller.isTimerEnabled ? CountdownTimer(
                                                endWidget: GestureDetector(
                                                  onTap: () {
                                                    controller.onGetCode(context);
                                                  },
                                                  child:controller.emailLoading ? const CupertinoActivityIndicator(
                                                    color: AppColor.appColor,
                                                  ) : const Text(
                                                    "Resend New Code",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColor.appColor,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                endTime: controller.endTime,
                                                onEnd: () {
                                                  controller.isTimerEnabled = false;
                                                },
                                                textStyle:  TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: FontSize.sp_14,
                                                  color: Theme.of(context).shadowColor,
                                                ),
                                              ) : controller.emailLoading ? const CupertinoActivityIndicator(
                                                color: AppColor.appColor,
                                              ) :TradeBitTextWidget(title: 'Get Code', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_13,color: AppColor.appColor)))
                                        ],
                                      ),
                                      VerticalSpacing(height: Dimensions.h_10), SizedBox(
                                        height: Dimensions.h_40,
                                        child: Padding(
                                          padding:  const EdgeInsets.only(),
                                          child: CupertinoTextField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [RemoveEmojiInputFormatter()],
                                            style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                                            controller:   controller.emailOtpController ,
                                            onChanged: (e) {
                                            },
                                            decoration:  BoxDecoration(
                                              color: Theme.of(context).scaffoldBackgroundColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            placeholder: 'Email Verification Code',
                                            placeholderStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                                          ),
                                        ),
                                      ),
                                      VerticalSpacing(height: Dimensions.h_8),
                                      TradeBitTextWidget(title: 'We have sent a verification code to ${widget.email}', style: AppTextStyle.normalTextStyle( FontSize.sp_11, Theme.of(context).shadowColor)),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: controller.mobileEnable ?? false,
                                  child: Column(
                                    children: [
                                      VerticalSpacing(height: Dimensions.h_20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TradeBitTextWidget(title: 'Mobile Verification Code', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor)),
                                          GestureDetector(
                                              onTap: () {
                                                controller.onMobileGetCode(context);
                                              },
                                              child:  controller.isTimerMobileEnabled ? CountdownTimer(
                                                endWidget: GestureDetector(
                                                  onTap: () {
                                                    controller.onGetCode(context);
                                                  },
                                                  child: controller.mobileLoading ? const CupertinoActivityIndicator(
                                                    color: AppColor.appColor,
                                                  ) : const Text(
                                                    "Resend New Code",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColor.appColor,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                endTime: controller.mobileEnd,
                                                onEnd: () {
                                                  controller.isTimerMobileEnabled = false;
                                                },
                                                textStyle:  TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: FontSize.sp_14,
                                                  color: Theme.of(context).shadowColor,
                                                ),
                                              ) : controller.mobileLoading ? const CupertinoActivityIndicator(
                                                color: AppColor.appColor,
                                              ) : TradeBitTextWidget(title: 'Get Code', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_13,color: AppColor.appColor)))
                                        ],
                                      ),
                                      VerticalSpacing(height: Dimensions.h_10),
                                      SizedBox(
                                        height: Dimensions.h_40,
                                        child: Padding(
                                          padding:  const EdgeInsets.only(),
                                          child: CupertinoTextField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [RemoveEmojiInputFormatter()],
                                            style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                                            controller:  controller.mobileOtpController ,
                                            onChanged: (e) {
                                            },
                                            decoration:  BoxDecoration(
                                              color: Theme.of(context).scaffoldBackgroundColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            placeholder: 'Mobile Verification Code',
                                            placeholderStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: controller.google2fa ?? false,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      VerticalSpacing(height: Dimensions.h_20),
                                      TradeBitTextWidget(title: 'Authenticator Verification Code', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor)),
                                      VerticalSpacing(height: Dimensions.h_10),
                                      SizedBox(
                                        height: Dimensions.h_40,
                                        child: Padding(
                                          padding:  const EdgeInsets.only(),
                                          child: CupertinoTextField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [RemoveEmojiInputFormatter()],
                                            style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                                            controller:   controller.googleOtpController ,
                                            onChanged: (e) {
                                            },
                                            decoration:  BoxDecoration(
                                              color: Theme.of(context).scaffoldBackgroundColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            placeholder: 'Authenticator Verification Code',
                                            placeholderStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalSpacing(height: Dimensions.h_5),
                                VerticalSpacing(height: Dimensions.h_20),
                                TradeBitTextButton(loading: controller.loading,labelName: 'Proceed', onTap: (){
                                  controller.loading ? null :controller.transferVerification(context);
                                  },margin: EdgeInsets.zero,color: AppColor.appColor,)
                              ],
                            ),
                          ),
                        ]
                    ),
                  )),
            ),
          ),
        );
      },
    );
  }
}
