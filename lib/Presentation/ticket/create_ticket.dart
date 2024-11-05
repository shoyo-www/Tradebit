import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/myfees/fees_controller.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';

class TicketCreateScreen extends StatelessWidget {
  const TicketCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TicketController ticketController = Get.put(TicketController());
    return WillPopScope(
      onWillPop: () async => true,
      child: TradeBitContainer(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: SafeArea(
          child: GetBuilder(
            init: ticketController,
            id: ControllerBuilders.ticketController,
            builder: (controller) {
              return TradeBitScaffold(
                appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_40), child: TradeBitAppBar(title: 'New Ticket',onTap: ()=> controller.getBack(context))),
                  body: Padding(
                    padding:  EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15),
                    child: Form(
                      key: controller.ticketKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VerticalSpacing(height: Dimensions.h_30),
                            TradeBitTextWidget(title: 'Subject', style: AppTextStyle.themeBoldNormalTextStyle(
                              fontSize: FontSize.sp_16,color: Theme.of(context).shadowColor
                            )),
                            VerticalSpacing(height: Dimensions.h_8),
                            buildTextField(context,'Enter Subject',controller.subController,Validator.subject),
                            VerticalSpacing(height: Dimensions.h_15),
                            TradeBitTextWidget(title: 'Ticket Type', style: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_16,color: Theme.of(context).shadowColor
                            )),
                            VerticalSpacing(height: Dimensions.h_8),
                            GestureDetector(
                                onTap: () {
                                  controller.showBottomSheetDeposit(context);
                                },
                                child: TradeBitContainer(
                                  margin: EdgeInsets.only(right: Dimensions.w_10),
                                  padding: EdgeInsets.only(left: Dimensions.w_8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  height: Dimensions.h_40,
                                  width: double.infinity,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TradeBitTextWidget(title: controller.category ?? "- -", style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor),)),
                                )),
                            HorizontalSpacing(width: Dimensions.w_12),
                            VerticalSpacing(height: Dimensions.h_15),
                            TradeBitTextWidget(title: 'Name', style: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_16,color: Theme.of(context).shadowColor
                            )),
                            VerticalSpacing(height: Dimensions.h_8),
                            buildTextField(context,'Enter Name',controller.nameController,Validator.usernameValidate),
                            VerticalSpacing(height: Dimensions.h_15),
                            TradeBitTextWidget(title: 'Email', style: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_16,color: Theme.of(context).shadowColor
                            )),
                            VerticalSpacing(height: Dimensions.h_8),
                            buildTextField(context,'Enter email',controller.emailController,Validator.emailValidate),
                            VerticalSpacing(height: Dimensions.h_15),
                            TradeBitTextWidget(title: 'Ticket Description', style: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_16,color: Theme.of(context).shadowColor,
                            )),
                            VerticalSpacing(height: Dimensions.h_8),
                            buildTextField(context,'How can be help you today',controller.ticketDesController,Validator.des,maxLines: 6),
                            VerticalSpacing(height: Dimensions.h_30),
                            TradeBitTextButton(
                              loading: controller.buttonLoading,
                                height: Dimensions.h_40,
                                borderRadius: BorderRadius.circular(6),
                                labelName: 'Submit', onTap: () {
                                  controller.ticketCreate(context, );
                            },
                            margin: EdgeInsets.zero)
                          ],
                        ),
                      ),
                    ),
                  )
              );
            },

          ),
        ),
      ),
    );
  }

  TextFormField buildTextField(BuildContext context,String placeholder,TextEditingController? controller,String? Function(String?)? validator,{int? maxLines}) {
    return  TextFormField(
      maxLines: maxLines,
      inputFormatters: [RemoveEmojiInputFormatter()],
      keyboardType: TextInputType.name,
      style: AppTextStyle.normalTextStyle(16, Theme.of(context).highlightColor),
      cursorColor: Theme.of(context).shadowColor,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        counterText: '',
        contentPadding:  EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.w_10),
        hintText: placeholder,
        hintStyle:AppTextStyle.normalTextStyle(FontSize.sp_16,Theme.of(context).shadowColor),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)
        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
    );
  }
}
