import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/tradebit_large_text.dart';


class TradeBitTextButton extends StatelessWidget {
  final String labelName;
  final EdgeInsets? margin;
  final void Function() onTap;
  final Color? color;
  final TextStyle? style;
  final double? height;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final bool loading;

   const TradeBitTextButton(
      {Key? key,
        required this.labelName,
        required this.onTap,
        this.color,
        this.margin,
        this.style,
        this.height,
        this.border,
        this.borderRadius,
        this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? Dimensions.h_45,
        margin: margin ?? EdgeInsets.only(
            left: Dimensions.w_15,
            right: Dimensions.w_15,
            top: Dimensions.h_10,
            bottom: Dimensions.h_10),
        decoration: BoxDecoration(
          color: color ?? AppColor.appColor,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          border: border
        ),
        child: loading ? const Center(
          child: CupertinoActivityIndicator(
            color: Colors.white,
          ),
        ): Center(
          child: TradeBitLargeTextWidget(
            style:  style ?? AppTextStyle.buttonTextStyle(),
            title: labelName,
          ),
        ),
      ),
    );
  }
}

class TradeBuyTextButton extends StatelessWidget {
  final EdgeInsets? margin;
  final void Function() onTap;
  final TextStyle? style;
  final double? height;
  final String? isSelected;
  final bool loading;

  const TradeBuyTextButton(
      {Key? key,
        this.margin,
        required this.onTap,
        this.style,
        this.height,
        this.isSelected,
        this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? Dimensions.h_45,
        margin: margin ?? EdgeInsets.only(
            left: Dimensions.w_15,
            right: Dimensions.w_15,
            top: Dimensions.h_10,
            bottom: Dimensions.h_10),
        decoration: BoxDecoration(
          color:  isSelected == 'Sell'? AppColor.redButton : AppColor.green,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: loading == true ? const CupertinoActivityIndicator(
            color: AppColor.white,
          ) : TradeBitLargeTextWidget(
            style:  style ?? AppTextStyle.buttonTextStyle(),
            title: isSelected == 'Sell'? 'Sell' : 'Buy',
          ),
        ),
      ),
    );
  }
}