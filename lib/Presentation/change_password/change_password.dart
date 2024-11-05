import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/change_password/change_password_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/setting/setting.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_passwordfield.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';
import 'package:tradebit_app/widgets/tradebit_textfield.dart';
import '../../constants/apptextstyle.dart';
import '../../constants/fontsize.dart';
import '../../widgets/tradebit_text.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}
class _ChangePasswordState extends State<ChangePassword> {
 final ChangePasswordController changePasswordController = Get.put(ChangePasswordController());
  @override
  Widget build(BuildContext context) {
    return TradeBitContainer(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor
      ),
      child: GetBuilder(
        init: changePasswordController,
        id: ControllerBuilders.changePasswordController,
        builder: (controller) {
          return SafeArea(
            child: WillPopScope(
              onWillPop: () async {
                pushReplacementWithSlideTransition(context, const Setting());
                return false;
              },
              child: TradeBitScaffold(
                isLoading: controller.isLoading,
                  appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55),child: TradeBitAppBar(onTap: ()=> pushReplacementWithSlideTransition(context, const Setting(),isBack: true))),
                  body: Form(
                    key: controller.changePasswordKey,
                    child: Padding(
                      padding:  EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VerticalSpacing(height: Dimensions.h_20),
                            Padding(
                              padding:  EdgeInsets.only(left: Dimensions.w_8,bottom: Dimensions.h_5),
                              child: TradeBitTextWidget(title: 'Old Password ', style: AppTextStyle.normalTextStyle(FontSize.sp_15,Theme.of(context).highlightColor)),
                            ),
                            TradeBitTextField(hintText: 'Enter Old Password', title: 'Old Password', controller: controller.oldPasswordController,validator: Validator.passwordOldValidate),
                            Padding(
                              padding:  EdgeInsets.only(left: Dimensions.w_8,bottom: Dimensions.h_5),
                              child: TradeBitTextWidget(title: 'New Password ', style: AppTextStyle.normalTextStyle(FontSize.sp_15,Theme.of(context).highlightColor)),
                            ),
                            TradeBitPasswordTextField(
                              obscureText: controller.closeEye,
                              title: 'New Password',
                              hintText: 'Enter new Password',
                              controller: controller.newPasswordController,
                              suffixIcon: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    controller.changeEye();
                                  },
                                  icon: Icon(
                                      controller.closeEye
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).shadowColor.withOpacity(0.4))),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: Dimensions.w_8,bottom: Dimensions.h_5),
                              child: TradeBitTextWidget(title: 'Confirm Password ', style: AppTextStyle.normalTextStyle(FontSize.sp_15,Theme.of(context).highlightColor)),
                            ),
                            TradeBitPasswordTextField(
                              obscureText: controller.closeConfirm,
                              title: 'Confirm Password',
                              hintText: 'Enter confirm Password',
                              controller: controller.confirmPasswordController,
                              suffixIcon: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    controller.changeEyeConfirm();
                                  },
                                  icon: Icon(
                                      controller.closeConfirm
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).shadowColor.withOpacity(0.4))),
                            ),
                            VerticalSpacing(height: Dimensions.h_1),
                            TradeBitTextButton(labelName: 'Change Password', onTap: ()=> controller.onResetButton(context),margin: EdgeInsets.only(top: Dimensions.h_12))
                          ],
                        ),
                      ),
                    ),
                  )
              ),
            ),
          );
        },
      ),
    );
  }
}