import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';

class LoginSelectionPage extends StatefulWidget {
  const LoginSelectionPage({Key? key}) : super(key: key);

  @override
  State<LoginSelectionPage> createState() => _LoginSelectionPageState();
}

class _LoginSelectionPageState extends State<LoginSelectionPage> {
  late  Image image;
  @override
  void initState() {
    super.initState();
    image = Image.asset(Images.loginSelection);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image.image, context);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: TradeBitScaffold(
          backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                TradeBitContainer(
                height: Dimensions.deviceHeight,
                width: Dimensions.deviceWidth,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(Images.loginSelection)),
                ),
              ),
              Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TradeBitTextWidget(title: 'Crypto Trading Simplified', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_30,color: Theme.of(context).highlightColor)),
            VerticalSpacing(height: Dimensions.h_20),
            TradeBitTextWidget(title: 'Trade Bitcoin, Ethereum, USDT, and \nthe top altcoins on the legendary\n crypto asset exchange.', textAlign: TextAlign.center,style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_18,color: Theme.of(context).shadowColor)),
            VerticalSpacing(height: Dimensions.h_30),
            TradeBitTextButton(
              style: AppTextStyle.themeBoldNormalTextStyle(
                  fontSize: FontSize.sp_18,
                  color: AppColor.white
              ),
              borderRadius: BorderRadius.circular(30),
              color: AppColor.appColor,
              labelName: 'Get Started',onTap: (){
              Get.toNamed(AppRoutes.register);
            },),
            TradeBitTextButton(
              borderRadius: BorderRadius.circular(30),
              color: AppColor.transparent,
              style: AppTextStyle.themeBoldNormalTextStyle(
                fontSize: FontSize.sp_18,
                color: AppColor.white
              ),
              border: Border.all(
                  color: Theme.of(context).shadowColor
              ),
              labelName: 'I have an account',onTap: (){
              Get.toNamed(AppRoutes.loginScreen);
            },),

                VerticalSpacing(height: Dimensions.h_20),
                GestureDetector(
                  onTap: () {
                     LocalStorage.writeBool(GetXStorageConstants.onBoarding, true);
                     LocalStorage.getBool(GetXStorageConstants.isLogin) == true ? null : LocalStorage.writeBool(GetXStorageConstants.isLogin, false);
                     LocalStorage.writeBool(GetXStorageConstants.basicFirst, true);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> DashBoard()));
                  },
                    child: TradeBitTextWidget(title: "Skip", style: AppTextStyle.bodyMediumTextStyle(
                      color: Theme.of(context).shadowColor
                    ))),
                VerticalSpacing(height: Dimensions.h_100),
          ],

        ),
              ],
            )
      ),
    );
  }
}
