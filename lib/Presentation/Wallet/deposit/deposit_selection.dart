import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit_controller.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit_screen.dart';
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

class DepositSelectionScreen extends StatefulWidget {
  final int? index;
  final List<Datum>? currencyNetwork;
  final List<CurrencyNetwork>? network;
  const DepositSelectionScreen({super.key,this.index,this.currencyNetwork,this.network});

  @override
  State<DepositSelectionScreen> createState() => _DepositSelectionScreenState();
}

class _DepositSelectionScreenState extends State<DepositSelectionScreen> {
  final DepositController controller = Get.put(DepositController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
    controller.showBottomSheetDeposit(context,widget.network);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      id: ControllerBuilders.depositController,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: TradeBitContainer(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor
          ),
          child: SafeArea(
            child: TradeBitScaffold(
              appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: 'Deposit',onTap: ()=> Navigator.pop(context))),
              bottomNavigationBar:  widget.network?[ 0].depositEnable == false ? const SizedBox.shrink() : Padding(
                padding:  EdgeInsets.only(bottom: Dimensions.h_15),
                child: TradeBitContainer(
                  height: Dimensions.h_40,
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
                            margin: EdgeInsets.only(left: Dimensions.w_30,right: Dimensions.w_30),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: AppColor.appColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TradeBitTextWidget(title: 'Share', style: AppTextStyle.themeBoldTextStyle(color: AppColor.white,fontSize: FontSize.sp_15)),
                                HorizontalSpacing(width: Dimensions.w_8),
                                Image.asset(Images.deposit,scale: 5,color: AppColor.white,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    TradeBitContainer(
                      margin: EdgeInsets.only(left: Dimensions.h_15,right: Dimensions.h_15,top: Dimensions.h_10),
                      decoration:  BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.only(top:Dimensions.h_10,bottom: Dimensions.h_12,left: Dimensions.h_15,right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TradeBitTextWidget(title: 'You can deposit cryptocurrency into your account\nin just two simple steps.', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).highlightColor)),
                          VerticalSpacing(height: Dimensions.h_20),
                          TradeBitTextWidget(title: 'Select Currency', style: AppTextStyle.themeBoldNormalTextStyle(
                              fontSize: FontSize.sp_16,
                              color: Theme.of(context).shadowColor
                          )),
                          VerticalSpacing(height: Dimensions.h_10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const DepositScreen()));
                            },
                            child: TradeBitContainer(
                                margin: EdgeInsets.only(right: Dimensions.h_12),
                                padding: EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_8),
                                height: Dimensions.h_35,
                                width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(6)
                              ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                    child: TradeBitTextWidget(title: widget.currencyNetwork?[widget.index ?? 0].symbol ?? '', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).shadowColor)))),
                          ),
                          VerticalSpacing(height: Dimensions.h_10),
                          Visibility(
                            visible: widget.network?[0].walletAddress?.isEmpty ?? false || widget.network?[0].walletAddress == null,
                            child: Column(
                              children: [
                                VerticalSpacing(height: Dimensions.h_15),
                                GestureDetector(
                                onTap: () {
                                 controller.isLoading ? null :
                                 controller.createWallet(context, widget.currencyNetwork?[widget.index ?? 0].currencyNetworks?[0].currencyNetworkCurrencyId ?? '', widget.currencyNetwork?[widget.index ?? 0].currencyNetworks?[0].networkId ?? '');
                                },
                                child: TradeBitContainer(
                                  margin: EdgeInsets.only(right: Dimensions.w_15),
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: AppColor.appColor,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(child: controller.isLoading ? const CupertinoActivityIndicator() : TradeBitTextWidget(title: 'Generate Wallet', style: AppTextStyle.themeBoldTextStyle(color: AppColor.white,fontSize: FontSize.sp_15))),
                                ),
                                ),
                              ],
                            ),),
                          Visibility(
                            visible: widget.network?[0].walletAddress?.isNotEmpty  ?? false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TradeBitTextWidget(title: 'Select Network', style: AppTextStyle.themeBoldNormalTextStyle(
                                    fontSize: FontSize.sp_16,
                                    color: Theme.of(context).shadowColor
                                )),
                                VerticalSpacing(height: Dimensions.h_10),
                                GestureDetector(
                                  onTap: () {
                                    controller.showBottomSheetDeposit(context,widget.network);
                                  },
                                  child: TradeBitContainer(
                                    padding: EdgeInsets.only(left: Dimensions.w_8),
                                    margin: EdgeInsets.only(right: Dimensions.h_12),
                                    height: Dimensions.h_35,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TradeBitTextWidget(title: controller.firstTime? controller.getSelf(widget.network![0].tokenType.toString()) : controller.getSelf(controller.tokenType ?? '') ?? '',style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor,))),
                                  ),
                                ),
                                VerticalSpacing(height: Dimensions.h_20),
                                Row(
                                  children: [
                                    SizedBox(
                                        height : Dimensions.h_130,
                                        child:  QrImageView(
                                          backgroundColor: AppColor.white,
                                          data: controller.walletAddress.toString(),
                                          version: QrVersions.auto,
                                          size: Dimensions.h_130,
                                          gapless: false,
                                        )),
                                    HorizontalSpacing(width: Dimensions.w_8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TradeBitTextWidget(title: 'Min Deposit', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_12,color: Theme.of(context).highlightColor),),
                                        VerticalSpacing(height: Dimensions.h_2),
                                        TradeBitTextWidget(title: widget.network?[0].depositMin ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor.withOpacity(0.9))),
                                        VerticalSpacing(height: Dimensions.h_20),
                                        TradeBitTextWidget(title: 'Expected Arrival', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_12,color : Theme.of(context).highlightColor),),
                                        VerticalSpacing(height: Dimensions.h_2),
                                        TradeBitTextWidget(title: "15 Network Confirmation", style: AppTextStyle.normalTextStyle(FontSize.sp_12,Theme.of(context).shadowColor.withOpacity(0.9) )),
                                        VerticalSpacing(height: Dimensions.h_20),
                                        TradeBitTextWidget(title: 'Expected Lock', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor),),
                                        VerticalSpacing(height: Dimensions.h_2),
                                        TradeBitTextWidget(title: "15 Network Confirmation", style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor.withOpacity(0.9))),
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
                                      Expanded(child: TradeBitTextWidget(title: controller.walletAddress ?? '' , style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor))),
                                      GestureDetector(
                                          onTap: () {
                                            controller.onCopyClipBoard(context);
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
                              Expanded(child: TradeBitTextWidget(textAlign: TextAlign.start,textOverflow: TextOverflow.visible,title: 'Send Only Using The (${controller.tokenType}) Network. Using Any Other Network Will Result In Loss Of  Funds.', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor))),
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
                              Expanded(child: TradeBitTextWidget(textOverflow: TextOverflow.visible,title: 'Deposit Only ${controller.tokenType} To This Deposit Address. Depositing Any Other Asset Will Result In A Loss Of Funds. ', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor))),
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
              ),),
          ),
          ),
        );
      },

    );
  }
  @override
  void dispose() {
    Get.delete<DepositController>();
    super.dispose();
  }

}
