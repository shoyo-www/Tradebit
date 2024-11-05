import 'package:flutter/material.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';


class LaunchPad extends StatelessWidget {
  const LaunchPad({super.key});
  @override
  Widget build(BuildContext context) {
    return TradeBitContainer(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SafeArea(
          child: TradeBitScaffold(
            appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55),
                child: TradeBitAppBar(title: 'Launchpad',onTap: ()=>
                    Navigator.pop(context)
                    )),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child:Image.asset(Images.comingSoon,scale: 1.5)
                ),
                VerticalSpacing(height: Dimensions.h_20),
                TradeBitTextWidget(title: 'Coming Soon', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_22, color: Theme.of(context).highlightColor)),
              ],
            ),
          ),
        )
    );
  }
}