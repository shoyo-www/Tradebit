import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/fontsize.dart';

class AppTextStyle {
  static TextStyle normalTextStyle(double fontSize, Color textColor) {
    return GoogleFonts.barlow(
        fontSize: fontSize,
        color: textColor,
        fontWeight: FontWeight.normal
    );
  }

  static TextStyle themeBoldTextStyle({double? fontSize ,Color? color}) {
    return GoogleFonts.barlow(
        fontSize: fontSize ?? FontSize.sp_24,
        color: color ?? Colors.black,
        fontWeight: FontWeight.bold
    );

  }
  static TextStyle themeBoldNormalTextStyle({double? fontSize ,Color? color}) {
    return  GoogleFonts.barlow(
        fontSize: fontSize ?? FontSize.sp_24,
        color: color ?? Colors.black,
        fontWeight: FontWeight.w500
    );


  }
  static buttonTextStyle({Color? color}) =>  GoogleFonts.barlow(
      fontSize: FontSize.sp_16,
      color: color ?? AppColor.white,
      fontWeight: FontWeight.w600
  );

  static bodyMediumTextStyle({Color? color}) =>  GoogleFonts.barlow(
      fontSize: FontSize.sp_13,
      color: color ?? Colors.black,
      fontWeight: FontWeight.w500
  );
}