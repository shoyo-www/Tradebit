import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tradebit_app/Presentation/Wallet/wallet_controller.dart';
import 'package:tradebit_app/Presentation/Wallet/withdraw/withdraw.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/walletListResponse.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class Deposit extends StatefulWidget {
   final int? index;
   final List<Datum>? currencyNetwork;
   final List<CurrencyNetwork>? network;
   final String symbol;

  const Deposit({super.key, this.index,this.currencyNetwork,this.network,required this.symbol});

  @override
  DepositState createState() => DepositState();
}

class DepositState extends State<Deposit>{

  final WalletController _controller = Get.put(WalletController());

  @override
  void initState() {
   _controller.getDepositStatus(context,widget.symbol);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      init: _controller,
      id: ControllerBuilders.walletController,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: TradeBitScaffold(
                isLoading: controller.walletLoading,
                appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: 'Deposit', onTap: ()=> Navigator.pop(context))),
                bottomNavigationBar: controller.depositEnable == false ? const SizedBox.shrink() : TradeBitContainer(
                  height: Dimensions.h_60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                           controller.onShareButton(widget.currencyNetwork?[widget.index ?? 0].symbol ?? '');
                          },
                          child: TradeBitContainer(
                            margin: EdgeInsets.only(left: Dimensions.w_30),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TradeBitTextWidget(title: 'Share', style: AppTextStyle.themeBoldTextStyle(color: AppColor.black,fontSize: FontSize.sp_15)),
                                HorizontalSpacing(width: Dimensions.w_8),
                                Image.asset(Images.deposit,scale: 5,color: Colors.black,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            pushWithSlideTransition(context, Withdraw(index: widget.index,
                              currencyNetwork: widget.currencyNetwork,
                              network: widget.network,
                            ));
                          },
                          child: TradeBitContainer(
                            margin: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: AppColor.appColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TradeBitTextWidget(title: 'Withdraw', style: AppTextStyle.themeBoldTextStyle(color: AppColor.white ,fontSize: FontSize.sp_15)),
                                HorizontalSpacing(width: Dimensions.w_8),
                                SizedBox(
                                  height: Dimensions.h_25,
                                    width: Dimensions.h_25,
                                    child: Image.asset(Images.withdrawLight)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: widget.network?[0].depositEnable == false ? Center(
                  child: Text(widget.network?[0].depositDesc ?? ''),
                ) : SingleChildScrollView(
                  child: Column(
                    children: [
                      TradeBitContainer(
                        margin: EdgeInsets.only(left: Dimensions.h_15,right: Dimensions.h_15),
                        decoration:  BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.only(top:Dimensions.h_15,bottom: Dimensions.h_12,left: Dimensions.h_15,right: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TradeBitTextWidget(title: 'Deposit ${widget.currencyNetwork?[widget.index ?? 0].symbol}', style: AppTextStyle.themeBoldTextStyle(color: Theme.of(context).highlightColor,fontSize: FontSize.sp_24)),
                            VerticalSpacing(height: Dimensions.h_8),
                            TradeBitTextWidget(title: 'You can deposit cryptocurrency into your account\nin just two simple steps.', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                            VerticalSpacing(height: Dimensions.h_20),
                            GestureDetector(
                              onTap: () {
                                controller.showCupertinoSheet(context, widget.network);
                              },
                              child: TradeBitContainer(
                                margin: EdgeInsets.only(right: Dimensions.h_12),
                                padding: EdgeInsets.only(left: Dimensions.w_10),
                                height: Dimensions.h_35,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TradeBitTextWidget(title: controller.firstTime ? controller.getSelf(widget.network?[0].tokenType ?? ''):controller.networkType ?? '',style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),)),
                              ),
                            ),
                            Visibility(
                              visible: controller.depositEnable == false ,
                              child: Column(
                                children: [
                                  VerticalSpacing(height: Dimensions.h_15),
                                  GestureDetector(
                                    onTap: () {
                                      controller.walletGenerate ? null :
                                      controller.createWallet(
                                          context,
                                          widget.currencyNetwork?[widget.index ?? 0].currencyNetworks?[0].currencyNetworkCurrencyId ?? '',
                                          widget.currencyNetwork?[widget.index ?? 0].currencyNetworks?[0].networkId ?? '',
                                          widget.symbol);
                                    },
                                    child: TradeBitContainer(
                                      margin: EdgeInsets.only(right: Dimensions.w_15),
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          color: AppColor.appColor,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Center(child: controller.walletGenerate ? const CupertinoActivityIndicator() : TradeBitTextWidget(title: 'Generate Wallet', style: AppTextStyle.themeBoldTextStyle(color: AppColor.white,fontSize: FontSize.sp_15))),
                                    ),
                                  ),
                                ],
                              ),),
                            Visibility(
                              visible: controller.depositEnable == true,
                              child: Column(
                                children: [
                                  VerticalSpacing(height: Dimensions.h_20),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: Dimensions.h_130,
                                          child: QrImageView(
                                              backgroundColor: Theme.of(context).highlightColor,
                                              version: QrVersions.auto,
                                              size: Dimensions.h_130,
                                              gapless: false,
                                              data: controller.firstTime ? (widget.network?[0].walletAddress ?? '')
                                                  : controller.walletAddress ?? '')),
                                      HorizontalSpacing(width: Dimensions.w_5),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TradeBitTextWidget(title: 'Min Deposit', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_12,color: Theme.of(context).highlightColor),),
                                          VerticalSpacing(height: Dimensions.h_2),
                                          TradeBitTextWidget(title: widget.currencyNetwork?[widget.index ?? 0].currencyNetworks![0].depositMin ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
                                          VerticalSpacing(height: Dimensions.h_20),
                                          TradeBitTextWidget(title: 'Expected Arrival', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_12,color: Theme.of(context).highlightColor),),
                                          VerticalSpacing(height: Dimensions.h_2),
                                          TradeBitTextWidget(title: "15 Network Confirmation", style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                          VerticalSpacing(height: Dimensions.h_20),
                                          TradeBitTextWidget(title: 'Expected Lock', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_12,color: Theme.of(context).highlightColor),),
                                          VerticalSpacing(height: Dimensions.h_2),
                                          TradeBitTextWidget(title: "15 Network Confirmation", style: AppTextStyle.normalTextStyle(FontSize.sp_12,Theme.of(context).shadowColor)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  VerticalSpacing(height: Dimensions.h_30),
                                  Container(
                                    margin: EdgeInsets.only(left: Dimensions.w_100),
                                    child: Row(
                                      children: [
                                        TradeBitContainer(
                                          margin: const EdgeInsets.only(right: 5),
                                          width: Dimensions.h_40,
                                          height: 1,
                                          decoration:  BoxDecoration(
                                              color: Theme.of(context).shadowColor
                                          ),
                                        ),
                                        TradeBitTextWidget(title: 'OR', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                        TradeBitContainer(
                                          margin: const EdgeInsets.only(left: 5),
                                          width: Dimensions.h_40,
                                          height: 1,
                                          decoration:  BoxDecoration(
                                              color: Theme.of(context).shadowColor
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalSpacing(height: Dimensions.h_20),
                                  TradeBitContainer(
                                    margin: EdgeInsets.only(right: Dimensions.w_10),
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: TradeBitTextWidget(title: controller.firstTime ? (widget.network?[0].walletAddress ?? '') : controller.walletAddress ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_14,Theme.of(context).highlightColor))),
                                        GestureDetector(
                                            onTap: () {
                                              controller.onCopyClipBoard(context, controller.firstTime ? (widget.network?[0].walletAddress ?? '') : controller.walletAddress ?? '');
                                            },
                                            child: Image.asset(Images.share_light,scale: 2.3)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                      TradeBitContainer(
                        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
                        margin: EdgeInsets.only(left: Dimensions.w_10, right: Dimensions.w_10,top: Dimensions.h_10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warning,color: AppColor.red,),
                                HorizontalSpacing(width: Dimensions.w_5),
                                Expanded(child: TradeBitTextWidget(title: 'Warnings', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_22, color: Theme.of(context).highlightColor))),
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
                                HorizontalSpacing(width: Dimensions.w_5),
                                Expanded(child: TradeBitTextWidget(textAlign: TextAlign.start,textOverflow: TextOverflow.visible,title: 'Send Only Using The (${controller.networkType}) Network. Using Any Other Network Will Result In Loss Of  Funds.', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor))),
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
                                HorizontalSpacing(width: Dimensions.w_5),
                                Expanded(child: TradeBitTextWidget(textOverflow: TextOverflow.visible,title: 'Deposit Only ${controller.networkType} To This Deposit Address. Depositing Any Other Asset Will Result In A Loss Of Funds. ', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor))),
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
                                HorizontalSpacing(width: Dimensions.w_5),
                                Expanded(child: TradeBitTextWidget(textOverflow: TextOverflow.visible,title: 'Please do not deposit any non - listed assets  to the given address above, it will be lost.', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor))),
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
                                HorizontalSpacing(width: Dimensions.w_5),
                                Expanded(child: TradeBitTextWidget(textOverflow: TextOverflow.visible,title: 'After your request has been filed, you will need to  confirm the network node.  After the 30 network confirmation, it will be credited. Once all 30 network  confirmations are  approved, you are allowed  to withdraw your assets.', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor))),
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
                                HorizontalSpacing(width: Dimensions.w_5),
                                Expanded(child: TradeBitTextWidget(textOverflow: TextOverflow.visible,title: 'Your wallet address will not change. However,  if it does, you  are advised to file an  inquiry. If there are any  changes, we will notify you through our website announcements or via email.', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor))),
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
                                HorizontalSpacing(width: Dimensions.w_5),
                                Expanded(child: TradeBitTextWidget(textOverflow: TextOverflow.visible,title: '  To prevent information from being tampered with or leaked, please make sure that your computer and Internet browser are safe.', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor))),
                              ],
                            ),
                            VerticalSpacing(height: Dimensions.h_40),

                          ],
                        ),
                      )
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
  Get.delete<WalletController>();
    super.dispose();
  }

}
