import 'package:flutter/material.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class TradeBitAppBar extends StatelessWidget {
  final double? height;
  final String? title;
  final Color? color;
  final void Function()? onTap;
   const TradeBitAppBar({super.key, this.height,this.title,this.onTap,this.color});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(height ?? Dimensions.h_50),
        child: TradeBitContainer(
          padding: EdgeInsets.only(bottom: Dimensions.h_5),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).scaffoldBackgroundColor
      ),
          child: Center(
            child: Row(
              children: [
                HorizontalSpacing(width: Dimensions.w_15),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTap,
                  child: TradeBitContainer(
                    height: Dimensions.h_25,
                    width: Dimensions.h_25,
                    margin: EdgeInsets.only(top: Dimensions.h_4),
                    padding:  EdgeInsets.only(left: Dimensions.w_5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.transparent,
                      border: Border.all(
                        color: Theme.of(context).shadowColor.withOpacity(0.3)
                      )
                    ),
                    child: const Icon(Icons.arrow_back_ios,size: 15,weight: 40,)
                  ),
                ),
                HorizontalSpacing(width: Dimensions.w_20),
                TradeBitTextWidget(title: title ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                  color: Theme.of(context).highlightColor,
                  fontSize: FontSize.sp_22
                ))
              ],
            ),
          ),
    ),
    );
  }
}
