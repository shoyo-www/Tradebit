import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/sendToken/sendtoken_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';
import '../../constants/images.dart';
import '../utils/validators.dart';

class SendToken extends StatefulWidget {
  const SendToken({super.key});
  @override
  State<SendToken> createState() => _SendTokenState();
}
class _SendTokenState extends State<SendToken> {
  final SendTokenController controller = Get.put(SendTokenController());
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    controller.getCrypto(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return TradeBitContainer(
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor
      ),
      child: SafeArea(
        child: GetBuilder(
          init: controller,
          id: ControllerBuilders.sendTokenController,
          builder: (controller) {
            return WillPopScope(
              onWillPop: () async => true,
              child: TradeBitScaffold(
                isLoading: controller.loading,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(Dimensions.h_40),
                    child: TradeBitAppBar(
                     title: 'Transfer',
                     onTap: ()=> Navigator.pop(context),
                        ),
                  ),
                  body: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Form(
                      key: key,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          VerticalSpacing(height: Dimensions.h_5),
                          Stack(
                            children: [
                              TradeBitContainer(
                                padding: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15,top: Dimensions.h_5,bottom: Dimensions.h_5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    VerticalSpacing(height: Dimensions.h_10),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        controller.showSheet(context);
                                      },
                                      child: Row(
                                        children: [
                                          TradeBitTextWidget(
                                              title: ' From',
                                              style: AppTextStyle.normalTextStyle(
                                                  FontSize.sp_15, Theme.of(context).shadowColor)),
                                          HorizontalSpacing(
                                            width: Dimensions.w_20,
                                          ),
                                          TradeBitTextWidget(
                                              title: controller.from,
                                              style: AppTextStyle.normalTextStyle(
                                                  FontSize.sp_15, Theme.of(context).highlightColor)),
                                          const Spacer(),
                                          Icon(Icons.keyboard_arrow_down_sharp,
                                              size: Dimensions.h_16,
                                              color: Theme.of(context).shadowColor),
                                        ],
                                      ),
                                    ),
                                    VerticalSpacing(height: Dimensions.h_20),
                                    TradeBitContainer(
                                      height: 1,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .shadowColor
                                              .withOpacity(0.1)),
                                    ),
                                    VerticalSpacing(height: Dimensions.h_10),
                                    Row(
                                      children: [
                                        TradeBitTextWidget(
                                            title: ' To',
                                            style: AppTextStyle.normalTextStyle(
                                                FontSize.sp_15, Theme.of(context).shadowColor)),
                                        HorizontalSpacing(
                                          width: Dimensions.w_35,
                                        ),
                                        TradeBitTextWidget(
                                            title: controller.to,
                                            style: AppTextStyle.normalTextStyle(
                                                FontSize.sp_15, Theme.of(context).highlightColor)),
                                        const Spacer(),
                                        InkWell(
                                          onTap: (){
                                            controller.showSheet(context);
                                          },
                                          child: Icon(Icons.keyboard_arrow_down_sharp,
                                              size: 18,
                                              color: Theme.of(context).shadowColor),
                                        ),
                                      ],
                                    ),
                                    VerticalSpacing(height: Dimensions.h_15),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: Dimensions.w_65,
                                  bottom: Dimensions.h_33,
                                  child: GestureDetector(
                                    onTap: (){
                                      controller.onButtonClick();
                                    },
                                      child: Image.asset(Images.sendToken,scale: 2.3,color: Theme.of(context).shadowColor.withOpacity(0.8),)))
                            ],
                          ),
                          VerticalSpacing(height: Dimensions.h_10),
                          Expanded(
                            child: TradeBitContainer(
                              padding: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15,bottom: Dimensions.h_5,top: Dimensions.h_15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    TradeBitTextWidget(
                                        title: '  Amount',
                                        style: AppTextStyle.normalTextStyle(
                                            14, Theme.of(context).highlightColor)),
                                    VerticalSpacing(height: Dimensions.h_13),
                                    TradeBitContainer(
                                      padding: const EdgeInsets.only(top: 5,bottom: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                              color: Theme.of(context).shadowColor.withOpacity(0.1)
                                          )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: Dimensions.w_185,
                                            child: CupertinoTextFormFieldRow(
                                              inputFormatters: [RemoveEmojiInputFormatter()],
                                              padding: EdgeInsets.only(
                                                  top: Dimensions.h_5,
                                                  bottom: Dimensions.h_5,
                                                  left: Dimensions.h_3
                                              ),
                                              validator: Validator.amount,
                                              style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              cursorColor: Theme.of(context).shadowColor,
                                              controller: controller.amountController,
                                              onChanged: (e) {
                                              },
                                              decoration: const BoxDecoration(
                                                color: Colors.transparent,
                                              ),
                                              placeholder: 'Enter Amount',
                                              placeholderStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    controller.showCupertinoSheet(context);
                                                  },
                                                  child: TradeBitContainer(
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                            height: Dimensions.h_20,
                                                            width: Dimensions.h_20,
                                                            child: TradebitCacheImage(image: controller.image ?? '')),
                                                        HorizontalSpacing(width: Dimensions.w_5),
                                                        TradeBitTextWidget(title: controller.symbol ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
                                                        HorizontalSpacing(width: Dimensions.w_5),
                                                      ],
                                                    ),
                                                  )),
                                              RotatedBox(quarterTurns: 1,
                                                  child: Icon(Icons.arrow_forward_ios,size: 10,color: Theme.of(context).shadowColor)),
                                              HorizontalSpacing(width: Dimensions.w_12),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    VerticalSpacing(height: Dimensions.h_10),
                                    Row(
                                      children: [
                                        TradeBitTextWidget(
                                            title: '  Available:',
                                            style: AppTextStyle.normalTextStyle(
                                                FontSize.sp_14, Theme.of(context).shadowColor)),
                                        const HorizontalSpacing(width: 2),
                                        TradeBitTextWidget(
                                            title: "${controller.firstTime ? controller.spotAmount ?? '---' : (controller.from == 'Fait and Spot' ? controller.spotAmount : controller.fundAmount) ?? '---'} ${controller.symbol ?? '--'}",
                                            style: AppTextStyle.normalTextStyle(
                                                FontSize.sp_14, AppColor.appcolor)),
                                      ],
                                    ),
                                    const Spacer(),
                                    TradeBitTextButton(
                                      loading: controller.button,
                                      margin: EdgeInsets.zero,
                                        labelName: 'Confirm Transfer', onTap: () {
                                        if(controller.amountController.text.isNotEmpty) {
                                          controller.onSendToken(context);
                                        }else {
                                          ToastUtils.showCustomToast(context, 'PLease enter amount', false);
                                        }
                                    }),
                                    VerticalSpacing(height: Dimensions.h_10)
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
            },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<SendTokenController>();
  }
}
