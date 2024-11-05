import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tradebit_app/Presentation/history/history_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/extensions.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_scaffold.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryController controller = Get.put(HistoryController());

  @override
  void initState() {
    controller.getHistory(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getSelf(String token) {
      if(token == 'SELF') {
        return 'MCOIN20';
      } else if(token == "ETH") {
        return 'ERC20';
      } else if(token == "TRX") {
        return 'TRC20';
      }
      return token;
    }
    return  GetBuilder(
      id: ControllerBuilders.historyController,
      init: controller,
      builder: ( controller) {
        return Container(
          color: Theme.of(context).cardColor,
          child: SafeArea(
            child: TradeBitScaffold(
              backgroundColor: Theme.of(context).cardColor,
                body: Column(
                  children: [
                    TradeBitAppBar(height: Dimensions.h_50,title: 'History',color : Theme.of(context).cardColor,onTap: (){
                      Navigator.pop(context);
                    },),
                    VerticalSpacing(height: Dimensions.h_20),
                    Padding(
                      padding:  EdgeInsets.only(left: Dimensions.w_5),
                      child: SizedBox(
                        height: Dimensions.h_30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.getIndex(index,context,controller.categories[index]);
                                  },
                                  child: TradeBitContainer(
                                    margin: const EdgeInsets.only(left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: controller.selectedIndex == index
                                          ? AppColor.appColor
                                          : Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          controller.categories[index],
                                          style: AppTextStyle.themeBoldTextStyle(
                                            fontSize: FontSize.sp_14,
                                            color: controller.selectedIndex == index ? AppColor.white : Theme.of(context).shadowColor
                                          )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    VerticalSpacing(height: Dimensions.h_10),
                    controller.loading ?  Expanded(
                      child: CupertinoActivityIndicator(
                        color: AppColor.appColor,
                        radius: Dimensions.h_12,
                      ),
                    ) :
                     (controller.deposit.isNotEmpty || controller.withdraw.isEmpty || controller.send.isEmpty || controller.transfer.isNotEmpty) ?  Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: (controller.type) == 'Deposit' ? controller.deposit.length :
                        (controller.type == 'Withdrawal') ? controller.withdraw.length :
                        (controller.type == 'Send') ? controller.send.length : controller.transfer.length,
                          itemBuilder: (c,i) {
                            String getTime( DateTime date) {
                              final dateTime = date.toDateString(DateFormats.hhmma) ?? '';
                              return dateTime;
                            }
                            String getDate( DateTime date) {
                              final dateTime = date.toDateString(DateFormats.ddMMMyyyy) ?? '';
                              return dateTime;
                            }
                        return  Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TradeBitTextWidget(title: (controller.type == 'Deposit') ? controller.deposit[i].symbol ?? '--' : (controller.type == 'Withdrawal') ? controller.withdraw[i].symbol ?? '--' :
                                    (controller.type == 'Send') ? controller.send[i].symbol ?? '--' : controller.transfer[i].symbol ?? '--', style: AppTextStyle.themeBoldNormalTextStyle(
                                    color: Theme.of(context).highlightColor,
                                    fontSize: FontSize.sp_16
                                  )),
                                  TradeBitTextWidget(title: (controller.type == 'Deposit') ? controller.deposit[i].amount.toString() ?? '--' : (controller.type == 'Withdrawal') ? controller.withdraw[i].amount.toString() ?? '--' :
                                  (controller.type == 'Send') ? controller.send[i].amount.toString() ?? '--' : controller.transfer[i].amount.toString() ?? '--', style: AppTextStyle.themeBoldNormalTextStyle(
                                      color: Theme.of(context).highlightColor,
                                      fontSize: FontSize.sp_16
                                  )),
                                ],
                              ),
                              VerticalSpacing(height: Dimensions.h_5),
                              Row(
                                children: [
                                  TradeBitContainer(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Theme.of(context).scaffoldBackgroundColor),
                                    child: TradeBitTextWidget(
                                        title: (controller.type == 'Deposit') ? getDate(controller.deposit[i].createdAt ?? DateTime(2)) :
                                        (controller.type == 'Withdrawal') ? getDate(controller.withdraw[i].createdAt ?? DateTime(2))  :
                                        (controller.type == 'Send') ? getDate(controller.send[i].createdAt ?? DateTime(2)):
                                        getDate(controller.transfer[i].createdAt ?? DateTime(2)),
                                        style: AppTextStyle.normalTextStyle(
                                          FontSize.sp_12,
                                          Theme.of(context).highlightColor.withOpacity(0.4),
                                        )),
                                  ),
                                  HorizontalSpacing(width: Dimensions.w_5),
                                  TradeBitContainer(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Theme.of(context).scaffoldBackgroundColor),
                                    child: TradeBitTextWidget(
                                        title: (controller.type == 'Deposit') ? getTime(controller.deposit[i].createdAt ?? DateTime(2)):
                                        (controller.type == 'Withdrawal') ? getTime(controller.withdraw[i].createdAt ?? DateTime(2)) :
                                        (controller.type == 'Send') ? getTime(controller.send[i].createdAt ?? DateTime(2)):
                                        getTime(controller.transfer[i].createdAt ?? DateTime(2)),
                                        style: AppTextStyle.normalTextStyle(
                                          FontSize.sp_12,
                                          Theme.of(context).highlightColor.withOpacity(0.4),
                                        )),
                                  ),
                                  HorizontalSpacing(width: Dimensions.w_5),
                                  TradeBitContainer(
                                    height: Dimensions.h_12,
                                    width : 1.1,
                                    decoration: const BoxDecoration(
                                      color: AppColor.appColor
                                    ),
                                  ),
                                  HorizontalSpacing(width: Dimensions.w_8),
                                  TradeBitContainer(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Theme.of(context).scaffoldBackgroundColor),
                                    child: TradeBitTextWidget(
                                        title: (controller.type == 'Deposit') ? getSelf(controller.deposit[i].tokenType ?? '--')  : (controller.type == 'Withdrawal') ? getSelf(controller.withdraw[i].tokenType ?? '--') :
                            (controller.type == 'Send') ? getSelf(controller.send[i].tokenType ?? '--') : getSelf(controller.transfer[i].tokenType ?? '--'),
                                        style: AppTextStyle.normalTextStyle(
                                          FontSize.sp_12,
                                          Theme.of(context).highlightColor.withOpacity(0.4),
                                        )),
                                  ),
                                  const Spacer(),
                                  TradeBitContainer(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color:  controller.deposit[i].status == 'completed'  ? const Color(0xFF23BB81) : Colors.red.withOpacity(0.3),width: 1.2)
                                    ),
                                    child:  TradeBitTextWidget(title: controller.deposit[i].status ?? '--', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_12, color:
                                    controller.deposit[i].status == 'completed' ? const Color(0xFF23BB81) : AppColor.redButton)),
                                  ),
                                ],
                              ),
                              VerticalSpacing(height: Dimensions.h_15),
                              Row(
                                children: [
                                  TradeBitTextWidget(title: 'Address: ', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_12, color : AppColor.appColor)),
                                  TradeBitTextWidget(title: (controller.type == 'Deposit') ? controller.deposit[i].userWalletAddress ?? '--' : (controller.type == 'Withdrawal') ? controller.withdraw[i].userWalletAddress ?? '--' :
                                  (controller.type == 'Send') ? controller.send[i].userWalletAddress ?? '--' : controller.transfer[i].userWalletAddress ?? '--', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_12, color : Theme.of(context).shadowColor)),
                                ],
                              ),
                              VerticalSpacing(height: Dimensions.h_10),
                              const Divider(thickness: 1),
                              VerticalSpacing(height: Dimensions.h_5),

                            ],
                          ),
                        );
                      }),
                    ) : (controller.deposit.isEmpty || controller.withdraw.isEmpty || controller.send.isEmpty || controller.transfer.isEmpty) ?  Expanded(
                         child: Padding(
                           padding:  EdgeInsets.only(top: Dimensions.h_80),
                           child: Column(
                             children: [
                               SizedBox(
                                   width: Dimensions.h_200,
                                   child: LottieBuilder.asset(Images.noDataFound)),
                               VerticalSpacing(height: Dimensions.h_30),
                               TradeBitTextWidget(title: 'No Data Found', style: AppTextStyle.themeBoldNormalTextStyle(
                                   fontSize: FontSize.sp_18,
                                   color: Theme.of(context).highlightColor
                               ))
                             ],
                           ),
                         )
                     ) : Expanded(
                         child: Padding(
                           padding:  EdgeInsets.only(top: Dimensions.h_80),
                           child: Column(
                             children: [
                               SizedBox(
                                   width: Dimensions.h_200,
                                   child: LottieBuilder.asset(Images.noDataFound)),
                               VerticalSpacing(height: Dimensions.h_30),
                               TradeBitTextWidget(title: 'No Data Found', style: AppTextStyle.themeBoldNormalTextStyle(
                                   fontSize: FontSize.sp_18,
                                   color: Theme.of(context).highlightColor
                               ))
                             ],
                           ),
                         )
                     )
                  ],
                )),
          ),
        );
      },

    );
  }
}
