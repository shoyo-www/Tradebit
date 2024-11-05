import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Homepage/home_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';

import '../constants/images.dart';
class TradeBitDrawer extends StatefulWidget {
  final HomeController? controller;
  const TradeBitDrawer({Key? key, this.controller}) : super(key: key);

  @override
  State<TradeBitDrawer> createState() => _TradeBitDrawerState();
}

class _TradeBitDrawerState extends State<TradeBitDrawer> {
  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      init: widget.controller,
      id: ControllerBuilders.homeController,
      builder: (controller) {
        return TradeBitScaffold(
          body: Column(
            children: [
              VerticalSpacing(height: Dimensions.h_20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Scaffold.of(context).closeEndDrawer(),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Get.isDarkMode
                            ? const Icon(CupertinoIcons.brightness)
                            : const Icon(
                          CupertinoIcons.moon_stars,
                        ),
                        onPressed: () {
                          LocalStorage().changeTheme();
                          Navigator.of(context).pop();
                        },
                      ),
                      IconButton(
                        icon:  const Icon(CupertinoIcons.person_2_alt),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:  EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20,top: Dimensions.h_20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(LocalStorage.getString(GetXStorageConstants.userProfile,)),
                    ),
                    HorizontalSpacing(width: Dimensions.w_20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TradeBitTextWidget(title: LocalStorage.getString(GetXStorageConstants.userEmail), style: AppTextStyle.normalTextStyle(FontSize.sp_15, AppColor.appColor)),
                        Row(
                          children: [
                            TradeBitTextWidget(title: 'UID : ', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Colors.black)),
                            TradeBitTextWidget(title: LocalStorage.getString(GetXStorageConstants.userName), style: AppTextStyle.normalTextStyle(FontSize.sp_12, Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              VerticalSpacing(height: Dimensions.h_30),
              const TradeBitContainer(
                width: double.infinity,
                height: 1,
                decoration: BoxDecoration(
                  color: AppColor.grey
                ),
              ),
              VerticalSpacing(height: Dimensions.h_15),
              buildRow('KYC(identification)', Images.kyc),
              buildRow('Security Verification',Images.security),
              // buildRow('Referral center'),
              buildRow('Change  Password',Images.kyc),
              // buildRow('Notification', Images.)
              // buildRow('My fees',Images.fee),


              // buildRow('My tickets'),
              TradeBitTextButton(labelName: 'Logout', onTap: () {
                  widget.controller?.showCupertinoDialogWithButtons(context);
              },)
            ],
          ),
        );
      },

    );
  }

  Padding buildRow(String title, String image ,{void Function()? onTap}) {
    return Padding(
      padding:  EdgeInsets.only(left: Dimensions.w_20,bottom: Dimensions.h_18,top: Dimensions.h_10,right: Dimensions.w_20),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
               children: [
                 Image.asset(image,scale: 2,),
                 HorizontalSpacing(width: Dimensions.w_15),
                 TradeBitTextWidget(title: title, style: AppTextStyle.normalTextStyle(FontSize.sp_15, AppColor.appColor))
               ],
             ),
      ),
    );
  }
}



