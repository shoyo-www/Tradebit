import 'package:flutter/material.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class EmailPhoneButton extends StatelessWidget {
  const EmailPhoneButton({Key? key,required this.title, required this.isSelected, this.onTap}) : super(key: key);
   final String title;
   final bool isSelected;
  final void Function()? onTap;
@override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TradeBitContainer(
            padding: EdgeInsets.only(bottom: Dimensions.h_5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ?  AppColor.appColor : AppColor.transparent,
                  width: 2
                )
              )

            ),
            child: TradeBitTextWidget(
                title: title,
                style: AppTextStyle.themeBoldTextStyle(
                    fontSize: FontSize.sp_16,
                color: isSelected ? AppColor.appColor : Theme.of(context).shadowColor)),
          ),
        ],
      ),
    );
  }
}
