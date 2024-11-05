import 'package:flutter/material.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/fontsize.dart';

class TradeBitLargeTextWidget extends StatelessWidget {
  final String title;
  final TextAlign textAlign;
  final TextStyle? style;
  const TradeBitLargeTextWidget(
      {Key? key, required this.title, this.textAlign = TextAlign.start,this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style ?? AppTextStyle.normalTextStyle(
          FontSize.sp_18, Colors.black),
      textAlign: textAlign,
    );
  }
}
