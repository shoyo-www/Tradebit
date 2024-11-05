import 'package:flutter/material.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/kyc_verfication/kyc_controller.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';
class KycVerified extends StatelessWidget {
  String message;
   KycVerified({super.key,required this.message});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: TradeBitContainer(
        padding: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20,top: Dimensions.h_80),
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 1.28,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
            )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Dimensions.h_100,
              width: Dimensions.h_100,
              child: Image.asset(Images.verifyKyc),
            ),
            VerticalSpacing(height: Dimensions.h_20),
            TradeBitTextWidget(title: 'Successfully', style: AppTextStyle.themeBoldNormalTextStyle(
              fontSize: FontSize.sp_24,
              color: Theme.of(context).highlightColor
            )),
            VerticalSpacing(height: Dimensions.h_20),
            TradeBitTextWidget(title: 'We are thrilled to inform you that your KYC\nVerification $message.\nYour support means a lot to us, and we thank\nyou for choosing our services.', style: AppTextStyle.themeBoldNormalTextStyle(
                fontSize: FontSize.sp_15,
                color: Theme.of(context).shadowColor,
            ),
            textAlign: TextAlign.center),
            const Spacer(),
            TradeBitTextButton(labelName: 'Home', onTap: () {
              LocalStorage.writeBool(GetXStorageConstants.kyc, true);
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DashBoard(index: 0)));
            },margin: EdgeInsets.zero,),
            VerticalSpacing(height: Dimensions.h_20),
          ],
        ),
      ),
    );
  }
}
