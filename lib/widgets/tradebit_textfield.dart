import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class TradeBitTextField extends StatelessWidget {
  const TradeBitTextField(
      {Key? key,
      required this.hintText,
        this.color,
        this.hintStyle,
        this.validator,
        this.height,
        this.contentPadding,
        this.borderEnable = true,
        this.inputFormatters,
        this.keyboardType,
        required this.title,
        required this.controller,
        this.onChanged,
      })
      : super(key: key);
  final String hintText;
  final String title;
  final bool borderEnable;
  final double? height;
  final TextEditingController controller;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final Color? color;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      cursorColor: Theme.of(context).shadowColor,
      controller: controller,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onChanged: onChanged,
      keyboardType: keyboardType ?? TextInputType.emailAddress,
      inputFormatters: inputFormatters ?? [RemoveEmojiInputFormatter()],
      decoration: InputDecoration(
          fillColor: color ?? Theme.of(context).cardColor,
          filled: true,
          isCollapsed: true,
          counterText: ' ',
        contentPadding: contentPadding ??  EdgeInsets.only(top: Dimensions.h_12,bottom: Dimensions.h_12,left: Dimensions.w_10),
          enabledBorder: OutlineInputBorder(
            borderSide:  borderEnable ? BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)) : const BorderSide(color: AppColor.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  borderEnable ? BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)) : const BorderSide(color: AppColor.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide:  BorderSide(width: 1, color: Theme.of(context).shadowColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide:  BorderSide(width: 1,color: Theme.of(context).shadowColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderSide:  borderEnable ? BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)) : const BorderSide(color: AppColor.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: hintText,
          hintStyle: hintStyle ?? AppTextStyle.normalTextStyle(FontSize.sp_16, AppColor.neutral_600)),
    );
  }
}


class TradeBitTextFieldLabel extends StatelessWidget {
  const TradeBitTextFieldLabel(
      {Key? key,
        required this.hintText,
        this.color,
        this.hintStyle,
        this.height,
        this.contentPadding,
        this.borderEnable = true,
        this.textColor,
        this.inputFormatters,
        this.keyboardType,
        required this.title,
        required this.controller,
        this.validator,
        this.maxLines,
        this.onChanged,
        this.enabled = true
      })
      : super(key: key);
  final String hintText;
  final String title;
  final bool borderEnable;
  final double? height;
  final TextEditingController controller;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final Color? color;
  final Color? textColor;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.only(left: Dimensions.w_5),
          child: TradeBitTextWidget(title: title, style: AppTextStyle.themeBoldNormalTextStyle(
            fontSize: FontSize.sp_14,
            color: textColor ?? Theme.of(context).shadowColor
          )),
        ),
        VerticalSpacing(height: Dimensions.h_10),
        TextFormField(
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          maxLines: maxLines ?? 1,
          enabled: enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          onChanged: onChanged,
          keyboardType: keyboardType ?? TextInputType.emailAddress,
          cursorColor: Theme.of(context).shadowColor,
          inputFormatters: inputFormatters ?? [RemoveEmojiInputFormatter()],
          controller: controller,
          style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor),
          decoration: InputDecoration(
              fillColor: color ?? Theme.of(context).cardColor,
              filled: true,
              counterText: ' ',
              contentPadding: contentPadding ?? EdgeInsets.only(top: Dimensions.h_12,bottom: Dimensions.h_12,left: Dimensions.w_10),
              enabledBorder: OutlineInputBorder(
                borderSide:  borderEnable ? BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)) : const BorderSide(color: AppColor.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:  borderEnable ? BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)) : const BorderSide(color: AppColor.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: borderEnable ? BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)) : const BorderSide(width: 1, color: AppColor.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1,color: AppColor.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              border: OutlineInputBorder(
                borderSide:  borderEnable ? BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)) : const BorderSide(color: AppColor.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: hintText,
              hintStyle: hintStyle ?? AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_13, color : Theme.of(context).shadowColor.withOpacity(0.5))),
        ),
      ],
    );
  }
}