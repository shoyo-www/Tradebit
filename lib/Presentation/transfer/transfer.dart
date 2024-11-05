import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/transfer/transfer_controller.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_scaffold.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';

class Transfer extends StatefulWidget {
  const Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  final TransferController controller = Get.put(TransferController());

  @override
  void initState() {
    controller.getCrypto(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      id: ControllerBuilders.transferController,
      builder: (controller) {
        return  WillPopScope(
          onWillPop: () async {
            LocalStorage.getBool(GetXStorageConstants.transferFromHome) == true ?
            pushReplacementWithSlideTransition(context,DashBoard(index: 0),isBack: true) :
            LocalStorage.getBool(GetXStorageConstants.fromExchange) == true ? pushReplacementWithSlideTransition(context,DashBoard(index: 2),isBack: true):
            Navigator.pop(context);
            return false;
          },
          child: TradeBitContainer(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor
            ),
            child: SafeArea(
              child: TradeBitScaffold(
                appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: 'Send Crypto',onTap: ()=>
                LocalStorage.getBool(GetXStorageConstants.transferFromHome) == true ?
                pushReplacementWithSlideTransition(context,DashBoard(index: 0),isBack: true) :
                LocalStorage.getBool(GetXStorageConstants.fromExchange) == true ? pushReplacementWithSlideTransition(context,DashBoard(index: 2),isBack: true):
                Navigator.pop(context)
                )),
                  body: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: SingleChildScrollView(
                      child: Form(
                        key: controller.key,
                        child: Column(
                          children: [
                            TradeBitContainer(
                              padding: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15,top: Dimensions.h_20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TradeBitTextWidget(title: 'Select Wallet Type', style: AppTextStyle.normalTextStyle(
                                      FontSize.sp_13,
                                   Theme.of(context).shadowColor,
                                  )),
                                  VerticalSpacing(height: Dimensions.h_5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.onSpot();
                                          },
                                          child: TradeBitContainer(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: controller.spot ? AppColor.appColor : Theme.of(context).cardColor,
                                                border: Border.all(
                                                  color:  controller.spot ? AppColor.transparent : Theme.of(context).shadowColor.withOpacity(0.2),
                                                ),
                                                borderRadius: BorderRadius.circular(4)
                                            ),
                                            child: Center(child: TradeBitTextWidget(title: 'Spot Wallet', style: AppTextStyle.normalTextStyle( FontSize.sp_15,controller.spot ? AppColor.white : Theme.of(context).shadowColor,))),
                                          ),
                                        ),
                                      ),
                                      HorizontalSpacing(width: Dimensions.w_20),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.onFunding();
                                          },
                                          child: TradeBitContainer(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:  controller.funding ? AppColor.transparent : Theme.of(context).shadowColor.withOpacity(0.2),
                                                ),
                                                color: controller.funding? AppColor.appColor : Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.circular(4)
                                            ),
                                            child: Center(child: TradeBitTextWidget(title: 'Funding', style: AppTextStyle.normalTextStyle( FontSize.sp_15,controller.funding ? AppColor.white : Theme.of(context).shadowColor))),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  VerticalSpacing(height: Dimensions.h_30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.onEmail();
                                        },
                                        child: TradeBitContainer(
                                          padding: EdgeInsets.only(bottom: Dimensions.h_5),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: controller.email ? AppColor.appColor : AppColor.transparent,
                                                width: 2
                                              ),
                                            ),
                                          ),
                                            child: TradeBitTextWidget(title: 'Email', style:
                                            AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_14, color: controller.email ? Theme.of(context).highlightColor : Theme.of(context).shadowColor))),
                                      ),
                                      HorizontalSpacing(width: Dimensions.w_15),
                                      GestureDetector(
                                        onTap: (){
                                          controller.onMobile();
                                        },
                                        child: TradeBitContainer(
                                            padding: EdgeInsets.only(bottom: Dimensions.h_5),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: controller.mobile ? AppColor.appColor : AppColor.transparent,
                                                    width: 2
                                                  ),
                                                ),
                                            ),
                                            child: TradeBitTextWidget(title: 'Mobile', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_14, color: controller.mobile ? Theme.of(context).highlightColor : Theme.of(context).shadowColor))),
                                      ),
                                      HorizontalSpacing(width: Dimensions.w_15),
                                      GestureDetector(
                                        onTap: () {
                                          controller.onUid();
                                        },
                                        child: TradeBitContainer(
                                            padding: EdgeInsets.only(bottom: Dimensions.h_5),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: controller.uid ? AppColor.appColor : AppColor.transparent,
                                                    width: 2
                                                  ),
                                                ),
                                            ),
                                            child: TradeBitTextWidget(title: 'Tradebit UID', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_14, color: controller.uid ? Theme.of(context).highlightColor :  Theme.of(context).shadowColor))),
                                      ),
                                      const SizedBox(),
                                    ],
                                  ),
                                  VerticalSpacing(height: Dimensions.h_10),
                                  TradeBitTextWidget(title: 'Recipient ${controller.recipient}', style: AppTextStyle.normalTextStyle( FontSize.sp_13, Theme.of(context).shadowColor)),
                                  VerticalSpacing(height: Dimensions.h_10),
                                  SizedBox(
                                    height: Dimensions.h_60,
                                    child: TextFormField(
                                      inputFormatters: [RemoveEmojiInputFormatter()],
                                      controller: (controller.email == true) ? controller.emailController : (controller.mobile == true) ? controller.mobileController : controller.uidController,
                                      validator: (controller.email == true) ? Validator.emailValidate : (controller.mobile == true) ? Validator.phoneNumberValidate : Validator.uid ,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      cursorColor: Theme.of(context).shadowColor,
                                      style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        filled: true,
                                        fillColor: Theme.of(context).cardColor,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).shadowColor.withOpacity(0.1),
                                          )
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Theme.of(context).shadowColor.withOpacity(0.1),
                                            )
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Theme.of(context).shadowColor.withOpacity(0.1),
                                            ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Theme.of(context).shadowColor.withOpacity(0.1),
                                            )
                                        ),
                                        hintText: 'Enter ${controller.recipient}',
                                        hintStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                                      ),
                                    ),
                                  ),
                                  VerticalSpacing(height: Dimensions.h_10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TradeBitTextWidget(title: 'Amount', style: AppTextStyle.normalTextStyle( FontSize.sp_13, Theme.of(context).shadowColor)),
                                      GestureDetector(
                                        onTap: () {
                                          controller.onMax();
                                        },
                                        child: TradeBitContainer(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            color: AppColor.appColor.withOpacity(0.3)
                                          ),
                                          child: TradeBitTextWidget(title: 'MAX', style: AppTextStyle.normalTextStyle( FontSize.sp_12,AppColor.appColor)),
                                        ),
                                      )
                                    ],
                                  ),
                                  VerticalSpacing(height: Dimensions.h_5),
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
                                              left: Dimensions.h_3),
                                            style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                            cursorColor: Theme.of(context).shadowColor,
                                            controller: controller.amountController,
                                            onChanged: (e) {
                                            controller.validateAmount(e);
                                            },
                                            onSaved: (e) {
                                              controller.validateAmount(e);
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
                                                         child: TradebitCacheImage(image: controller.image ?? '',)),
                                                     HorizontalSpacing(width: Dimensions.w_5),
                                                     TradeBitTextWidget(title: controller.symbol ?? '- -', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
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
                                  VerticalSpacing(height: Dimensions.h_4),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TradeBitTextWidget(title: controller.validation ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_12, AppColor.red)),
                                  ),
                                  VerticalSpacing(height: Dimensions.h_8),
                                  Row(
                                    children: [
                                      TradeBitTextWidget(title: 'Available: ', style: AppTextStyle.normalTextStyle(FontSize.sp_16,Theme.of(context).shadowColor)),
                                      TradeBitTextWidget(title: controller.spot == true ? double.parse(controller.spotAmount ?? '00').toStringAsFixed(8) : double.parse(controller.fundAmount ?? '00').toStringAsFixed(8), style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_16, color: AppColor.appColor)),
                                      TradeBitTextWidget(title: ' ${controller.symbol}', style: AppTextStyle.normalTextStyle(FontSize.sp_15,Theme.of(context).shadowColor)),
                                    ],
                                  ),
                                  TradeBitTextButton(loading: controller.loading, labelName: 'Next', onTap: () {
                                      controller.transfer(context);
                                      },
                                  margin: EdgeInsets.only(top: Dimensions.h_20,bottom: Dimensions.h_20),
                                  color: AppColor.appColor,
                                    height: Dimensions.h_40,
                                  )
                                ],
                              ),
                            ),
                            VerticalSpacing(height: Dimensions.h_10),
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
          ),
        );
      },

    );
  }

  @override
  void dispose() {
   Get.delete<TransferController>();
    super.dispose();
  }
}
