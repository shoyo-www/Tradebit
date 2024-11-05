import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Homepage/home_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/setting/setting.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class MyFees extends StatefulWidget {
  const MyFees({super.key});

  @override
  State<MyFees> createState() => _MyFeesState();
}

class _MyFeesState extends State<MyFees> {
  bool valueButton = false;
 final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        pushReplacementWithSlideTransition(context, const Setting(),isBack: true);
        return false;
      },
      child: TradeBitContainer(
        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
        child: SafeArea(
          child: TradeBitScaffold(
              appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: 'My Fees',onTap: ()=> Navigator.pop(context))),
              body: GetBuilder(
                init: controller,
                id: ControllerBuilders.homeController,
                builder: (controller) {
                  return Padding(
                    padding:  EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15,top: Dimensions.h_10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TradeBitTextWidget(title: 'Pay trading fees with TBC', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_18,color: Theme.of(context).highlightColor)),
                            Transform.scale(
                              scale: 0.7,
                              child: CupertinoSwitch(
                                value: controller.feesButton,
                                onChanged: (v){
                                 controller.onFees(v, context);
                                },
                                thumbColor: AppColor.white,
                                activeColor: AppColor.appcolor,

                              ),
                            )
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        TradeBitTextWidget(title: 'Enable this option to pay trading fees with:', style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).shadowColor)),
                        VerticalSpacing(height: Dimensions.h_8),
                        TradeBitTextWidget(title: '1. TBC you buy from the exchange.', style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).shadowColor)),
                        VerticalSpacing(height: Dimensions.h_3),
                        TradeBitTextWidget(title: '2. Unlocked TBC balance reserved for trading fees.', style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).shadowColor)),
                        VerticalSpacing(height: Dimensions.h_20),
                        TradeBitTextWidget(
                            textAlign: TextAlign.center,
                            title: "Note: You'll get 50% discount if you pay fees via TBC.", style: AppTextStyle.normalTextStyle(FontSize.sp_15, AppColor.appColor))
                      ],
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }
}
