import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tradebit_app/Presentation/myfees/fees_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class TicketSupportScreen extends StatefulWidget {
  final int cId;
  final int tID;
  const TicketSupportScreen({super.key, required this.cId, required this.tID});

  @override
  State<TicketSupportScreen> createState() => _TicketSupportScreenState();
}

class _TicketSupportScreenState extends State<TicketSupportScreen> {

  TicketController ticketController = Get.put(TicketController());

  @override
  void initState() {
    super.initState();
    ticketController.getTicketSupport(context,widget.tID);
  }

  @override
  Widget build(BuildContext context) {
    return  TradeBitContainer(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor
      ),
      child: SafeArea(
        child: GetBuilder(
          init: ticketController,
          id: ControllerBuilders.ticketController,
          builder: (controller) {
            return TradeBitScaffold(
              isLoading: controller.isLoading,
                bottomNavigationBar: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        HorizontalSpacing(width: Dimensions.w_10),
                        Expanded(
                          child: Padding(
                            padding:  EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                            child: SizedBox(
                              height: Dimensions.h_35,
                              child: CupertinoTextField(
                                style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                                cursorColor: Theme.of(context).shadowColor.withOpacity(0.6),
                                cursorHeight: 14,
                                padding: const EdgeInsets.only(top: 0,left: 10),
                                controller: controller.chatController,
                                decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).shadowColor.withOpacity(0.6)
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                placeholder: 'Reply',
                                placeholderStyle: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).shadowColor),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.createTicket(context, widget.cId, widget.tID);
                          },
                            child: controller.buttonLoading == true ? const CupertinoActivityIndicator(color: AppColor.appColor): Icon(Icons.send,size: 25,color: Theme.of(context).highlightColor)),
                        HorizontalSpacing(width: Dimensions.w_15),
                      ],
                    ),
                  ),
                ),
                appBar:  PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_40), child: TradeBitAppBar(title: 'Chat with us ',onTap: ()=> Navigator.pop(context))),
                body: Column(
                  children: [
                    VerticalSpacing(height: Dimensions.h_20),
                     controller.comments.isEmpty ? Padding(
                       padding:  EdgeInsets.only(top: Dimensions.h_100,left: Dimensions.w_70),
                       child: Column(
                         children: [
                           SizedBox(
                               width: Dimensions.h_200,
                               child: LottieBuilder.asset(Images.noDataFound)),
                           VerticalSpacing(height: Dimensions.h_30),
                           TradeBitTextWidget(title: 'No Chat Found', style: AppTextStyle.themeBoldNormalTextStyle(
                               fontSize: FontSize.sp_18,
                               color: Theme.of(context).highlightColor
                           ))
                         ],
                       ),
                     ): Expanded(
                      child: ListView.builder(
                        physics: const ScrollPhysics(),
                        itemCount: controller.comments.length,
                        shrinkWrap: true,
                        padding:  EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10),
                        itemBuilder: (context, index){
                          return Container(
                            padding:  EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15,top: Dimensions.h_10,bottom: Dimensions.h_10),
                            child: Align(
                              alignment: controller.comments[index].commentedBy == '1' ? Alignment.topLeft : Alignment.topRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: controller.comments[index].commentedBy  == '1' ?  Theme.of(context).cardColor : AppColor.appColor,
                                ),
                                padding:  EdgeInsets.all(Dimensions.h_10),
                                child: Text(controller.comments[index].comment ?? '- - - - ', style: const TextStyle(fontSize: 15)),
                              ),
                            ),
                          );
                        },
                      ),)
                  ],
                ));
          },

        ),
      ),
    );
  }
}
