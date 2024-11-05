import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/staking/staking_controller.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';

class Redeem extends StatefulWidget {
  const Redeem({super.key});

  @override
  State<Redeem> createState() => _RedeemState();
}

class _RedeemState extends State<Redeem> {
  final StakingController controller = Get.put(StakingController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.getFundStake(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      id: ControllerBuilders.stakingController,
      builder: (controller) {
        return TradeBitContainer(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor
          ),
          child: SafeArea(
            child: TradeBitScaffold(
              appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: 'Redeem Earnings',onTap: () {
                controller.amount.clear();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> DashBoard(index: 3)));
              } )),
              body: SingleChildScrollView(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding:  EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VerticalSpacing(height: Dimensions.h_30),
                          TradeBitTextWidget(title: 'Earning transfer to spot wallet', style: AppTextStyle.normalTextStyle(FontSize.sp_15, Theme.of(context).shadowColor)),
                          VerticalSpacing(height: Dimensions.h_30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VerticalSpacing(height: Dimensions.h_10),
                              TradeBitTextWidget(title: 'Select Coin', style: AppTextStyle.themeBoldTextStyle(color: Theme.of(context).shadowColor,fontSize: FontSize.sp_14)),
                              VerticalSpacing(height: Dimensions.h_10),
                              GestureDetector(
                                onTap: () {
                                  controller.showBottomSheetDeposit(context);
                                },
                                child: TradeBitContainer(
                                  padding: EdgeInsets.only(left: Dimensions.w_8),
                                  margin: EdgeInsets.only(right: Dimensions.h_12),
                                  height: Dimensions.h_40,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TradeBitTextWidget(title: controller.stakeCurrency,style: AppTextStyle.normalTextStyle(FontSize.sp_16, Theme.of(context).highlightColor))),
                                ),
                              ),
                              VerticalSpacing(height: Dimensions.h_20),
                              Padding(
                                padding:  EdgeInsets.only(right: Dimensions.w_15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TradeBitTextWidget(title: 'Amount', style: AppTextStyle.themeBoldTextStyle(color: Theme.of(context).shadowColor,fontSize: FontSize.sp_14)),
                                    GestureDetector(
                                      onTap: ()=> controller.onStakeMax(),
                                        child: TradeBitTextWidget(title: 'Max', style: AppTextStyle.themeBoldTextStyle(color: AppColor.appColor,fontSize: FontSize.sp_16))),
                                  ],
                                ),
                              ),
                              VerticalSpacing(height: Dimensions.h_10),
                              SizedBox(
                                height: Dimensions.h_40,
                                child: Padding(
                                  padding:  EdgeInsets.only(right: Dimensions.h_12),
                                  child: TextFormField(
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                                    cursorColor: Theme.of(context).shadowColor,
                                    inputFormatters: [RemoveEmojiInputFormatter()],
                                    controller: controller.amount,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.only(top: Dimensions.h_15,bottom: Dimensions.h_10,left: Dimensions.w_10),
                                      hintText: "Enter Amount",
                                      hintStyle:AppTextStyle.normalTextStyle(FontSize.sp_16,Theme.of(context).shadowColor),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      filled: true,
                                      fillColor: Theme.of(context).cardColor,
                                    ),
                                  ),
                                ),
                              ),
                              VerticalSpacing(height: Dimensions.h_15),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TradeBitTextWidget(title: 'Available: ', style: AppTextStyle.themeBoldTextStyle(color: Theme.of(context).shadowColor,fontSize: FontSize.sp_14)),
                              TradeBitTextWidget(title: double.parse(controller.stakeBalance).toStringAsFixed(8), style: AppTextStyle.themeBoldTextStyle(color: AppColor.appColor,fontSize: FontSize.sp_14)),
                              HorizontalSpacing(width: Dimensions.w_20),
                            ],
                          ),
                          VerticalSpacing(height: Dimensions.h_30),
                          TradeBitTextButton(
                              labelName: 'Redeem',
                              onTap: (){
                                if(controller.amount.text.isNotEmpty) {
                                  controller.redeem(context);
                                } else {
                                  ToastUtils.showCustomToast(context, 'Please enter amount', false);
                                }
                              }, color: AppColor.appColor,
                              height: Dimensions.h_38,
                              margin: EdgeInsets.only(right: Dimensions.w_15),
                              loading: controller.buttonLoading,
                          ),
                          VerticalSpacing(height: Dimensions.h_40)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

      },
    );
  }
}
