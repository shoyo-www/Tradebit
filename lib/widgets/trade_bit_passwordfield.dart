import 'package:flutter/material.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class TradeBitPasswordTextField extends StatelessWidget {
  const TradeBitPasswordTextField(
      {Key? key,
      required this.hintText,
      required this.title,
      this.suffixIcon,
      required this.controller,this.obscureText = true})
      : super(key: key);
  final String hintText;
  final String title;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: Validator.passwordValidate,
      cursorColor: AppColor.neutral_500,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      obscuringCharacter: '*',
      inputFormatters: [RemoveEmojiInputFormatter()],
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        isCollapsed: true,
        fillColor: Theme.of(context).cardColor,
        counterText: " ",
        contentPadding: EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.w_10),
          enabledBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: suffixIcon,
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.red),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide:  BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hintText,
          hintStyle:
              AppTextStyle.normalTextStyle(FontSize.sp_16, Theme.of(context).shadowColor)),
    );
  }
}
