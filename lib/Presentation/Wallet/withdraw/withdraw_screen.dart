import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/Wallet/withdraw/withdraw_controller.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/walletListResponse.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';

class WithdrawScreen extends StatefulWidget {
  final int? index;
  final List<Datum>? currencyNetwork;
  final String? currency;
  final List <CurrencyNetwork>? network;
  const WithdrawScreen({super.key, this.index, this.currencyNetwork, this.currency,this.network});
  @override
  State<WithdrawScreen> createState() => _WithdrawStateSreen();
}

class _WithdrawStateSreen extends State<WithdrawScreen> {
  final WithDrawController withDrawController = Get.put(WithDrawController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: withDrawController,
      id: ControllerBuilders.withdrawController,
      builder: (controller) {
        return TradeBitContainer(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor
          ),
          child: SafeArea(
            bottom: false,
            child: TradeBitScaffold(
              appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: 'Withdraw',onTap: ()=>
              Navigator.pop(context)
              )),
              body: widget.currencyNetwork?[widget.index ?? 0].withdrawEnable == false ? Center(
                child: TradeBitTextWidget(title: widget.currencyNetwork?[widget.index ?? 0].withdrawDesc.toString() ?? '- - -',
                    style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_18,color: Theme.of(context).highlightColor)),
              ) : SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      TradeBitContainer(
                        margin: EdgeInsets.only(left: Dimensions.h_15,right: Dimensions.h_15),
                        decoration:  BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        padding: EdgeInsets.only(top:Dimensions.h_15,bottom: Dimensions.h_12,left: Dimensions.h_15,right: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VerticalSpacing(height: Dimensions.h_8),
                            TradeBitTextWidget(title: 'You can withdraw cryptocurrency from your\n account in just two simple steps.', style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).shadowColor)),
                            VerticalSpacing(height: Dimensions.h_20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TradeBitTextWidget(
                                    title: 'Destination Address', style: AppTextStyle.themeBoldTextStyle(color: Theme.of(context).highlightColor,fontSize: FontSize.sp_14)),
                                VerticalSpacing(height: Dimensions.h_5),
                                SizedBox(
                                  height: Dimensions.h_40,
                                  child: Padding(
                                    padding:  EdgeInsets.only(right: Dimensions.h_12),
                                    child: TextFormField(
                                      inputFormatters: [RemoveEmojiInputFormatter()],
                                      style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                                      cursorColor: Theme.of(context).shadowColor,
                                      controller: controller.address,
                                      validator: Validator.address,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: Dimensions.h_15,bottom: Dimensions.h_10,left: Dimensions.w_10),
                                        isCollapsed: true,
                                        hintText: "Enter Destination Address",
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
                                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                                VerticalSpacing(height: Dimensions.h_10),
                                TradeBitTextWidget(title: 'Select Network', style: AppTextStyle.themeBoldTextStyle(color: Theme.of(context).highlightColor,fontSize: FontSize.sp_14)),
                                VerticalSpacing(height: Dimensions.h_10),
                                GestureDetector(
                                  onTap: () {
                                    controller.showCupertinoSheet(context, widget.network);
                                  },
                                  child: TradeBitContainer(
                                    padding: EdgeInsets.only(left: Dimensions.w_8),
                                    margin: EdgeInsets.only(right: Dimensions.h_12),
                                    height: Dimensions.h_40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TradeBitTextWidget(title: " ${controller.token}",style: AppTextStyle.normalTextStyle(FontSize.sp_16, Theme.of(context).shadowColor))),
                                  ),
                                ),
                                VerticalSpacing(height: Dimensions.h_10),
                                TradeBitTextWidget(title: 'Amount', style: AppTextStyle.themeBoldTextStyle(color: Theme.of(context).highlightColor,fontSize: FontSize.sp_14)),
                                VerticalSpacing(height: Dimensions.h_10),
                                SizedBox(
                                  height: Dimensions.h_40,
                                  child: Padding(
                                    padding:  EdgeInsets.only(right: Dimensions.h_12),
                                    child: TextFormField(
                                      inputFormatters: [RemoveEmojiInputFormatter()],
                                      style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                                      cursorColor: Theme.of(context).shadowColor,
                                      controller: controller.amount,
                                      keyboardType: const TextInputType.numberWithOptions(
                                        decimal: true
                                      ),
                                      validator: Validator.amount,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: Dimensions.h_15,bottom: Dimensions.h_10,left: Dimensions.w_10),
                                        isCollapsed: true,
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
                                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                                VerticalSpacing(height: Dimensions.h_15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        TradeBitTextWidget(title: ' Fees: ', style: AppTextStyle.themeBoldTextStyle(color: Theme.of(context).shadowColor,fontSize: FontSize.sp_14)),
                                        TradeBitTextWidget(title: widget.network?[0].withdrawCommission ?? '', style: AppTextStyle.themeBoldTextStyle(color: Theme.of(context).shadowColor,fontSize: FontSize.sp_14)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        TradeBitTextWidget(title: 'Available: ', style: AppTextStyle.themeBoldTextStyle(color: Theme.of(context).shadowColor,fontSize: FontSize.sp_14)),
                                        TradeBitTextWidget(title: ' ${double.parse(widget.currencyNetwork?[widget.index ?? 0].quantity ?? '0.0').toStringAsFixed(8)} ${widget.currencyNetwork?[widget.index ?? 0].symbol}     ', style: AppTextStyle.themeBoldTextStyle(color: AppColor.appColor,fontSize: FontSize.sp_14)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            VerticalSpacing(height: Dimensions.h_30),
                            TradeBitTextButton(
                                labelName: 'Proceed',
                                onTap: () {
                                  controller.buttonLoading ? null : controller.walletWithdraw(context,widget.currency ?? '', widget.currencyNetwork?[widget.index ?? 0].cBal ?? '0.0');
                                }, color: AppColor.appColor,
                                height: Dimensions.h_40,
                                margin: EdgeInsets.only(right: Dimensions.w_15),
                                loading: controller.buttonLoading)
                          ],
                        ),
                      ),
                      TradeBitContainer(
                        padding: const EdgeInsets.all(12),
                        margin: EdgeInsets.only(left: Dimensions.h_15,right: Dimensions.h_15,top: Dimensions.h_30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warning,color: AppColor.red,),
                                HorizontalSpacing(width: Dimensions.w_5),
                                TradeBitTextWidget(title: 'Warnings', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_22, color: Theme.of(context).highlightColor)),
                              ],
                            ),
                            VerticalSpacing(height: Dimensions.h_15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TradeBitContainer(
                                  margin: const EdgeInsets.only(top: 4),
                                  height: Dimensions.h_8,
                                  width: Dimensions.h_8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Theme.of(context).shadowColor
                                  ),
                                ),
                                TradeBitTextWidget(title: '   Please Double-Check The Destination Address.\n   Withdrawal Requests Cannot Be Cancelled After \n   Submission.', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
                              ],
                            ),
                            VerticalSpacing(height: Dimensions.h_10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TradeBitContainer(
                                  margin: const EdgeInsets.only(top: 4),
                                  height: Dimensions.h_8,
                                  width: Dimensions.h_8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Theme.of(context).shadowColor
                                  ),
                                ),
                                TradeBitTextWidget(title: '   Withdrawals To Smart Contract Addresses \n   Will Be Lost Forever.', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
                              ],
                            ),
                            VerticalSpacing(height: Dimensions.h_5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TradeBitContainer(
                                  margin: const EdgeInsets.only(top: 4),
                                  height: Dimensions.h_8,
                                  width: Dimensions.h_8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Theme.of(context).shadowColor
                                  ),
                                ),
                                Expanded(child: TradeBitTextWidget(textOverflow: TextOverflow.visible,title: ' After your request has been filed, you will need to confirm the network node. After the 30 network confirmation,it will be credited. Once all 30 network confirmations are approved, you are allowed to withdraw your assets..', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor))),
                              ],
                            ),
                            VerticalSpacing(height: Dimensions.h_5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TradeBitContainer(
                                  margin: const EdgeInsets.only(top: 4),
                                  height: Dimensions.h_8,
                                  width: Dimensions.h_8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Theme.of(context).shadowColor
                                  ),
                                ),
                                TradeBitTextWidget(title: '  Your wallet address will not change. However, if it \n does, you are advised to file an inquiry. If there \n are any changes, we will notify you through our\n website announcements or via email.', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      VerticalSpacing(height: Dimensions.h_20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
@override
  void dispose() {
   Get.delete<WithDrawController>();
    super.dispose();
  }
}