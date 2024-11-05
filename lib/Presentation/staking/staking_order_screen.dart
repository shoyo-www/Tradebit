import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit_screen.dart';
import 'package:tradebit_app/Presentation/staking/staking_controller.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/staking.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';

class StakingOrderScreen extends StatefulWidget {
  final String? symbol;
  final List <Datum>? stakingList;
  final DateTime? date;
  final int? index;
  const StakingOrderScreen({super.key, this.symbol, this.stakingList,this.index,this.date});

  @override
  State<StakingOrderScreen> createState() => _StakingOrderScreenState();
}

class _StakingOrderScreenState extends State<StakingOrderScreen> {
  final StakingController stakingController = Get.put(StakingController());
  DateTime? dateTime;
   String? dateInterestEnd;
   String? redeemDate;
   String? subDate;

  @override
  void initState() {
    stakingController.getFund(context, widget.symbol ?? '');
    stakingController.planId = widget.stakingList![widget.index ?? 0].sData!.flexible365!.id;
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        stakingController.getBack(context);
        return false;
      },
      child: TradeBitContainer(
          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: SafeArea(
              child: GetBuilder(
                init: stakingController,
                id: ControllerBuilders.stakingController,
                builder: (controller) {
                  subDate = DateFormat.yMMMd().format(widget.date!);
                  dateTime = widget.date;
                  dateTime = dateTime?.add( Duration(days: controller.selectedIndex == 1 ? 90 : controller.selectedIndex == 2 ? 180 :  365));
                  DateTime? rd = dateTime?.add(const Duration(days: 1));
                  redeemDate = DateFormat.yMMMd().format(rd!);
                  dateInterestEnd = DateFormat.yMMMd().format(dateTime!);
                  return  TradeBitScaffold(
                      isLoading: stakingController.isLoading,
                      appBar: PreferredSize(
                          preferredSize: Size.fromHeight(Dimensions.h_50),
                          child: TradeBitAppBar(
                              title: 'Product Details',
                              onTap: () => controller.getBack(context))),
                      body: Padding(
                        padding: EdgeInsets.only(
                            left: Dimensions.w_15, right: Dimensions.w_15),
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Form(
                            key: controller.stakingKey,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TradeBitContainer(
                                    padding: EdgeInsets.only(
                                        left: Dimensions.w_10,
                                        right: Dimensions.w_10,
                                        top: Dimensions.h_15,
                                        bottom: Dimensions.h_15),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TradeBitTextWidget(
                                            title: '${widget.symbol} Hold & Earn',
                                            style:
                                            AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_16,
                                                color: Theme.of(context)
                                                    .highlightColor)),
                                        VerticalSpacing(height: Dimensions.h_20),
                                        TradeBitTextWidget(
                                            title: 'Subscribe to ${widget.symbol}',
                                            style:
                                            AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: Theme.of(context)
                                                    .highlightColor)),
                                        VerticalSpacing(height: Dimensions.h_10),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                controller.onButtonFlexible(widget.stakingList?[widget.index?? 0].sData?.flexible365?.id ?? 0, widget.stakingList?[widget.index ?? 0].sData?.flexible365?.roiPercentage ?? '');
                                              },
                                              child: TradeBitContainer(
                                                padding: const EdgeInsets.only(
                                                    top: 4, bottom: 5, left: 15, right: 15),
                                                decoration: BoxDecoration(
                                                    color: controller.flexibleButton
                                                        ? AppColor.appColor
                                                        : Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                    borderRadius:
                                                    BorderRadius.circular(6)),
                                                child: Center(
                                                    child: TradeBitTextWidget(
                                                        title: 'Flexible',
                                                        style: AppTextStyle
                                                            .themeBoldTextStyle(
                                                            color: controller.flexibleButton ? AppColor.white : Theme.of(context).shadowColor,
                                                            fontSize: FontSize.sp_12))),
                                              ),
                                            ),
                                            HorizontalSpacing(width: Dimensions.w_10),
                                            Visibility(
                                              visible: widget.stakingList?[widget.index ?? 0].aPlanTypes?.contains('fixed') ?? false,
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller.onFixedButton(context,widget.stakingList?[widget.index ?? 0].sData?.fixed365?.roiPercentage ?? '');
                                                },
                                                child: TradeBitContainer(
                                                  padding: const EdgeInsets.only(top: 4, bottom: 5, left: 15, right: 15),
                                                  decoration: BoxDecoration(
                                                      color: controller.fixedButton ? AppColor.appColor : Theme.of(context).scaffoldBackgroundColor,
                                                      borderRadius:
                                                      BorderRadius.circular(6)),
                                                  child: Center(
                                                      child: TradeBitTextWidget(
                                                          title: 'Fixed',
                                                          style: AppTextStyle
                                                              .themeBoldTextStyle(
                                                              color: controller.fixedButton
                                                                  ? AppColor.white
                                                                  : Theme.of(context)
                                                                  .shadowColor,
                                                              fontSize:
                                                              FontSize.sp_12))),
                                                ),
                                              ),
                                            ),
                                            HorizontalSpacing(width: Dimensions.w_8),
                                            Visibility(
                                                visible: controller.isVisible && widget.stakingList?[widget.index ?? 0].oPlanDays?.fixed?.length !=0,
                                                child: SizedBox(
                                                  height: Dimensions.h_20,
                                                  child: ListView.builder(
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.horizontal,
                                                  itemCount: widget.stakingList?[widget.index ?? 0].oPlanDays?.fixed?.length ?? 0,itemBuilder: (c,i) {
                                                    return  Padding(
                                                      padding:  EdgeInsets.only(right: Dimensions.w_10),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          int data;
                                                          if(widget.stakingList?[widget.index ?? 0].oPlanDays?.fixed?[i] == 0) {
                                                            data = widget.stakingList?[widget.index ?? 0].sData?.fixed365?.id ?? 0;
                                                          }
                                                          controller.onIndex(i,widget.stakingList?[widget.index ?? 0].sData);
                                                        },
                                                        child: TradeBitContainer(
                                                          padding: const EdgeInsets.only(top: 4, bottom: 5, left: 10, right: 10),
                                                          decoration: BoxDecoration(
                                                              color: controller.selectedIndex == i ? AppColor.appColor : Theme.of(context).scaffoldBackgroundColor,
                                                              borderRadius:
                                                              BorderRadius.circular(6)),
                                                          child: Center(
                                                              child: TradeBitTextWidget(
                                                                  title: widget.stakingList?[widget.index ?? 0].oPlanDays?.fixed?[i].toString() ?? '',
                                                                  style: AppTextStyle
                                                                      .themeBoldTextStyle(
                                                                      color: controller.selectedIndex == i
                                                                          ? AppColor.white
                                                                          : Theme.of(context)
                                                                          .shadowColor,
                                                                      fontSize:
                                                                      FontSize.sp_12))),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                               )
                                          ],
                                        ),
                                        VerticalSpacing(height: Dimensions.h_20),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            TradeBitTextWidget(
                                                title: 'Subscription amount',
                                                style: AppTextStyle
                                                    .themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_13,
                                                    color: Theme.of(context)
                                                        .highlightColor)),
                                            GestureDetector(
                                              onTap: () {
                                                controller.onMax();
                                              },
                                              child: TradeBitContainer(
                                                padding: const EdgeInsets.only(
                                                    top: 4,
                                                    bottom: 5,
                                                    left: 15,
                                                    right: 15),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(6),
                                                    color: AppColor.appColor),
                                                child: TradeBitTextWidget(
                                                    title: 'MAX',
                                                    style: AppTextStyle
                                                        .themeBoldTextStyle(
                                                        fontSize:
                                                        FontSize.sp_11,
                                                        color: AppColor.white)),
                                              ),
                                            )
                                          ],
                                        ),
                                        VerticalSpacing(height: Dimensions.h_10),
                                        Stack(
                                          children: [
                                            TextFormField(
                                              cursorColor: Theme.of(context).shadowColor,
                                              controller: controller.amountController,
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).highlightColor),
                                              inputFormatters: [RemoveEmojiInputFormatter()],
                                              decoration: InputDecoration(
                                                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                                                  filled: true,
                                                  counterText: ' ',
                                                  contentPadding:  const EdgeInsets.all(10),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:   const BorderSide(color: AppColor.transparent),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:   const BorderSide(color: AppColor.transparent),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(width: 1, color: AppColor.red),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedErrorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(width: 1,color: AppColor.red),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide:  const BorderSide(color: AppColor.transparent),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  hintText: 'Enter amount',
                                                  hintStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            TradeBitTextWidget(
                                                title: 'Available:',
                                                style: AppTextStyle
                                                    .themeBoldNormalTextStyle(
                                                  fontSize: FontSize.sp_12,
                                                  color: Theme.of(context).shadowColor,
                                                )),
                                            TradeBitTextWidget(
                                                title: ' ${controller.availBal}',
                                                style: AppTextStyle
                                                    .themeBoldNormalTextStyle(
                                                  fontSize: FontSize.sp_12,
                                                  color: AppColor.appColor,
                                                )),
                                          ],
                                        ),
                                        VerticalSpacing(height: Dimensions.h_18),
                                        TradeBitTextWidget(
                                            title: 'Amount Limitation',
                                            style:
                                            AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_13,
                                                color: Theme.of(context)
                                                    .highlightColor)),
                                        VerticalSpacing(height: Dimensions.h_10),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            TradeBitTextWidget(
                                                title: 'Minimum ${widget.stakingList?[widget.index ?? 0].sData?.flexible365?.minStakeAmount ?? ''} ${widget.symbol}',
                                                style: AppTextStyle
                                                    .themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_13,
                                                    color: Theme.of(context)
                                                        .shadowColor)),
                                            TradeBitTextWidget(
                                                title: 'Maximum ${widget.stakingList?[widget.index ?? 0].sData?.flexible365?.maxStakeAmount ?? ''} ${widget.symbol}',
                                                style: AppTextStyle
                                                    .themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_13,
                                                    color: Theme.of(context)
                                                        .shadowColor)),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            LocalStorage.writeBool(GetXStorageConstants.stakingDeposit, true);
                                            Navigator.push(context, MaterialPageRoute(builder: (c)=> const DepositScreen()));
                                          },
                                          child: TradeBitContainer(
                                            margin: EdgeInsets.only(top: Dimensions.h_15),
                                            padding: EdgeInsets.only(
                                                top: Dimensions.h_10,
                                                bottom: Dimensions.h_10,
                                                left: 8,
                                                right: 8),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                TradeBitTextWidget(
                                                    title: 'Don’t have enough crypto?',
                                                    style: AppTextStyle
                                                        .themeBoldNormalTextStyle(
                                                        fontSize: FontSize.sp_12,
                                                        color: Theme.of(context)
                                                            .shadowColor
                                                            .withOpacity(0.6))),
                                                TradeBitTextWidget(
                                                    title: 'Deposit Now',
                                                    style: AppTextStyle
                                                        .themeBoldNormalTextStyle(
                                                        fontSize: FontSize.sp_13,
                                                        color: AppColor.appColor)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TradeBitContainer(
                                    margin: EdgeInsets.only(top: Dimensions.h_12,bottom: Dimensions.h_20),
                                    padding: EdgeInsets.only(
                                        left: Dimensions.w_10,
                                        right: Dimensions.w_10,
                                        top: Dimensions.h_15,
                                        bottom: Dimensions.h_15),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TradeBitTextWidget(
                                            title: 'Summary',
                                            style:
                                            AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_17,
                                                color: Theme.of(context)
                                                    .highlightColor)),
                                        VerticalSpacing(height: Dimensions.h_20),
                                        buildRow(context, "Subscription Date:",subDate.toString() ),
                                        VerticalSpacing(height: Dimensions.h_8),
                                        buildRow(context, "Value Date:", subDate.toString()),
                                        VerticalSpacing(height: Dimensions.h_8),
                                        buildRow(context, "Interest End Date:", dateInterestEnd ?? '' ),
                                        VerticalSpacing(height: Dimensions.h_8),
                                        buildRow(context, "Redemption Date:", redeemDate ?? ''),
                                        VerticalSpacing(height: Dimensions.h_18),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [

                                            TradeBitTextWidget(
                                                title: 'Est.APR',
                                                style: AppTextStyle.themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_14,
                                                    color: Theme.of(context).highlightColor)),

                                            TradeBitTextWidget(
                                                title: controller.firstTime ?  "${widget.stakingList?[widget.index ?? 0].sData?.flexible365?.roiPercentage ?? ''} %" : "${controller.estApr}%",
                                                style: AppTextStyle
                                                    .themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_14,
                                                    color: Colors.green))
                                          ],
                                        ),
                                        VerticalSpacing(height: Dimensions.h_8),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            TradeBitTextWidget(
                                                title: 'Est.Interest',
                                                style: AppTextStyle.themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_14,
                                                    color: Theme.of(context).highlightColor)),

                                            TradeBitTextWidget(
                                                title: '-- --',
                                                style: AppTextStyle.themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_14,
                                                    color: Colors.green))
                                          ],
                                        ),
                                        VerticalSpacing(height: Dimensions.h_16),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: ()=> controller.onAgreeButton(),
                                              child: TradeBitContainer(
                                                margin: EdgeInsets.only(top: Dimensions.h_5),
                                                height: Dimensions.h_12,
                                                width: Dimensions.h_12,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Theme.of(context).shadowColor,width: 0.3),
                                                  borderRadius: BorderRadius.circular(Dimensions.h_2),
                                                    color:  Theme.of(context).scaffoldBackgroundColor),
                                                child: controller.agreeButton ? const Center(child: Icon(Icons.check,color: AppColor.appColor,size: 12,)) : const SizedBox()
                                              ),
                                            ),
                                            HorizontalSpacing(width: Dimensions.w_10),
                                            Expanded(child: GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                controller.onAgreeButton();
                                              },
                                                child: TradeBitTextWidget(textOverflow: TextOverflow.visible,title: 'I have read and I agree to Tradebit Simple Earn Service Agreement Confirm', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor))))
                                          ],
                                        ),
                                        VerticalSpacing(height: Dimensions.h_20),
                                        TradeBitTextButton(
                                          loading: controller.buttonLoading,
                                          labelName: 'Subscribe', onTap: () {
                                          controller.stakingSub(context);
                                        },margin: EdgeInsets.zero,)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                        },
                      ))),
    );

  }

  Row buildRow(BuildContext context, String title, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            TradeBitContainer(
              height: Dimensions.h_6,
              width: Dimensions.h_6,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).shadowColor.withOpacity(0.8)),
            ),
            HorizontalSpacing(width: Dimensions.w_10),
            TradeBitTextWidget(
                title: title,
                style: AppTextStyle.normalTextStyle(
                    FontSize.sp_14, Theme.of(context).shadowColor))
          ],
        ),
        TradeBitTextWidget(
            title: date,
            style: AppTextStyle.themeBoldNormalTextStyle(
                fontSize: FontSize.sp_14,
                color: Theme.of(context).highlightColor))
      ],
    );
  }
}
