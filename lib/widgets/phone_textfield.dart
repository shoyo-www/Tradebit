import 'package:flutter/material.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class PhoneNumberTextField extends StatelessWidget {
  final String? hintText;
  final String? phoneNumber;
  final String? title;
  final TextEditingController? phoneController;
  final void Function()? onTap;
  final String? name;

   const PhoneNumberTextField(
      {Key? key, this.hintText, this.phoneNumber, required this.title, this.phoneController,this.onTap,this.name})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap ?? (){},
          child: Container(
            margin: EdgeInsets.only(bottom: Dimensions.h_15),
            padding: EdgeInsets.only(
                top: Dimensions.h_10, bottom: Dimensions.h_15),
            width: Dimensions.h_75,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Theme.of(context).shadowColor.withOpacity(0.3)
              )
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  HorizontalSpacing(width: Dimensions.w_5),
                  TradeBitTextWidget(
                    title: phoneNumber ?? "+91" ,
                    style:
                        AppTextStyle.bodyMediumTextStyle(color: Theme.of(context).highlightColor),
                  ),
                  TradeBitTextWidget(
                    title: name ?? 'IND',
                    style:
                    AppTextStyle.bodyMediumTextStyle(color: Theme.of(context).highlightColor),
                  ),
                  const Icon(Icons.arrow_drop_down,color: AppColor.neutral_400,),
                ],
              ),
            ),
          ),
        ),
        HorizontalSpacing(width: Dimensions.h_10),
        Expanded(
          child: SizedBox(
            height: Dimensions.h_60,
            child: TextFormField(
              style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
              validator: Validator.phoneNumberValidate,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [RemoveEmojiInputFormatter()],
              decoration: InputDecoration(
                fillColor: Theme.of(context).cardColor,
                filled: true,
                counterText: ' ',
                contentPadding: const EdgeInsets.all(20),
                  enabledBorder: OutlineInputBorder(
                    borderSide:  BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:  BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)),
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
                    borderSide:  BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: hintText,
                  hintStyle: AppTextStyle.normalTextStyle(
                      FontSize.sp_16, Theme.of(context).shadowColor.withOpacity(0.3))),
            ),
          ),
        )
      ],
    );
  }
}
