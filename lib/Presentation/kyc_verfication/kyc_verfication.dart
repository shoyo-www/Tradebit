import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/kyc_verfication/kyc_controller.dart';
import 'package:tradebit_app/Presentation/kyc_verfication/verification_screen.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';
import 'package:tradebit_app/widgets/tradebit_textfield.dart';

class KycVerification extends StatefulWidget {
  const KycVerification({super.key});

  @override
  State<KycVerification> createState() => _KycVerificationState();
}

class _KycVerificationState extends State<KycVerification> {
  @override
  Widget build(BuildContext context) {
    final KycController kycController = Get.put(KycController());
    return WillPopScope(
      onWillPop: () async {
        pushReplacementWithSlideTransition(context, DashBoard(index: 0),isBack: true);
        return false;
      },
      child: TradeBitContainer(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: GetBuilder(
          id: ControllerBuilders.kycController,
          init: kycController,
          builder: (controller) {
            return SafeArea(
              child: TradeBitScaffold(
                  appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55),child: TradeBitAppBar(title: 'Verify Kyc',
                      onTap: ()=> pushReplacementWithSlideTransition(context, DashBoard(index: 0),isBack: true)
                  )),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        VerticalSpacing(height: Dimensions.h_15),
                        Padding(
                          padding:  EdgeInsets.only(left: Dimensions.h_10,right: Dimensions.h_10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  TradeBitTextWidget(title: 'Person Details', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15,color: controller.personalDetails ? AppColor.appcolor : Theme.of(context).shadowColor)),
                                  VerticalSpacing(height: Dimensions.h_5),
                                  TradeBitContainer(
                                    height: Dimensions.h_2,
                                    width: Dimensions.w_100,
                                    decoration:  BoxDecoration(
                                      color: controller.personalDetails ? AppColor.appColor : Theme.of(context).shadowColor,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  TradeBitTextWidget(title: 'ID Proof', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15,color: controller.id ? AppColor.appcolor : Theme.of(context).shadowColor)),
                                  VerticalSpacing(height: Dimensions.h_5),
                                  TradeBitContainer(
                                    height: Dimensions.h_2,
                                    width: Dimensions.w_100,
                                    decoration:  BoxDecoration(
                                      color: controller.id ? AppColor.appColor : Theme.of(context).shadowColor,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  TradeBitTextWidget(title: 'Done', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15,color: controller.done ? AppColor.appcolor : Theme.of(context).shadowColor)),
                                  VerticalSpacing(height: Dimensions.h_5),
                                  TradeBitContainer(
                                    height: Dimensions.h_2,
                                    width: Dimensions.w_100,
                                    decoration: BoxDecoration(
                                      color: controller.done ? AppColor.appColor : Theme.of(context).shadowColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        VerticalSpacing(height: Dimensions.h_45),
                        callPage(controller.index,controller)
                      ],
                    ),
                  )),
            );
            },
        ),
      ),
    );
  }
  @override
  void dispose() {
   Get.delete<KycController>();
    super.dispose();
  }
}

Widget callPage(int i,KycController controller) {
  switch (i) {
    case 0:
      return  KycDetails(controller: controller);

    case 1:
      return  VerificationKyc(controller: controller);


    default:
      return  KycDetails(controller: controller);
  }
}

class KycDetails extends StatefulWidget {
  final KycController controller;
  const KycDetails({
    super.key,
    required this.controller
  });

  @override
  State<KycDetails> createState() => _KycDetailsState();
}

class _KycDetailsState extends State<KycDetails> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return TradeBitContainer(
      padding: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20,top: Dimensions.h_20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
        )
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              TradeBitTextWidget(title: 'Enter Your Details', style: AppTextStyle.themeBoldNormalTextStyle(
                fontSize: FontSize.sp_17,
                color: Theme.of(context).highlightColor
              )),
            VerticalSpacing(height: Dimensions.h_15),
            TradeBitTextFieldLabel(
              keyboardType: TextInputType.name,
                hintText: 'Enter your name',
                title: 'Name',
                controller: widget.controller.nameController,
                borderEnable: false,
                color: Theme.of(context).scaffoldBackgroundColor,
                validator: Validator.usernameValidate),
            TradeBitTextFieldLabel(
              hintText: 'Enter your Last name',
              title: 'Last Name',
              controller: widget.controller.lastController,
              borderEnable: false,
              color: Theme.of(context).scaffoldBackgroundColor,
              validator: Validator.lastNameValidate,),
            Row(
              children: [
                Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: Dimensions.w_5),
                      child: TradeBitTextWidget(title: 'Select Gender', style: AppTextStyle.themeBoldNormalTextStyle(
                          fontSize: FontSize.sp_14,
                          color: Theme.of(context).shadowColor
                      )),
                    ),
                    VerticalSpacing(height: Dimensions.h_10),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        widget.controller.showSheet(context);
                      },
                      child: TradeBitContainer(
                        margin: EdgeInsets.only(bottom: Dimensions.h_18),
                        padding: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15),
                        height: Dimensions.h_40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TradeBitTextWidget(title: widget.controller.gender, style: AppTextStyle.themeBoldNormalTextStyle(
                              fontSize: FontSize.sp_12,
                              color: Theme.of(context).shadowColor,
                            )),
                            RotatedBox(quarterTurns: 1,
                            child: Icon(Icons.arrow_forward_ios,size: 12,color: Theme.of(context).shadowColor,)),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
                HorizontalSpacing(width: Dimensions.h_10),
                GetBuilder(
                  id: ControllerBuilders.datePicker,
                  init: widget.controller,
                  builder: (controller) {
                    return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TradeBitTextWidget(title: 'Date of Birth', style: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_14,
                                color: Theme.of(context).shadowColor
                            )),
                            VerticalSpacing(height: Dimensions.h_10),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                widget.controller.showDatePicker(context);
                              },
                              child: TradeBitContainer(
                                margin: EdgeInsets.only(bottom: Dimensions.h_18),
                                height: Dimensions.h_40,
                                padding: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).scaffoldBackgroundColor
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TradeBitTextWidget(title: widget.controller.date, style: AppTextStyle.themeBoldNormalTextStyle(
                                      fontSize: FontSize.sp_12,
                                      color: Theme.of(context).shadowColor,
                                    )),
                                    RotatedBox(quarterTurns: 1,
                                        child: Icon(Icons.arrow_forward_ios,size: 12,color: Theme.of(context).shadowColor,)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ));
                  },
                ),
              ],
            ),
            VerticalSpacing(height: Dimensions.h_5),
            TradeBitTextFieldLabel(
              height: Dimensions.h_80,
              hintText: 'Enter your address',
              title: 'Address',
              controller: widget.controller.addressController,
              borderEnable: false,
              color: Theme.of(context).scaffoldBackgroundColor,
                maxLines: 3,
                validator: Validator.address),
            VerticalSpacing(height: Dimensions.h_10),
            TradeBitTextButton(labelName: 'Next', onTap: () {
              if(formKey.currentState!.validate()) {
                if (widget.controller.date.isNotEmpty) {
                    var age = DateTime.now().year - (widget.controller.selectedDate?.year ?? DateTime.now().year);
                    if (age >= 18) {
                      widget.controller.onNextTapped(context);
                    } else {
                      ToastUtils.showCustomToast(context, 'Age must be greater than 18', false);
                    }
                  } else {
                  ToastUtils.showCustomToast(context, 'Select Age', false);
                }

              }
              },margin: EdgeInsets.zero,),
            VerticalSpacing(height: Dimensions.h_10),
          ],
        ),
      ),
    );
  }
}
