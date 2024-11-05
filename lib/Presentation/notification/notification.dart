import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/notification/notification_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController notificationController = Get.put(NotificationController());
  ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset >= scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        notificationController.loadMoreNotifications(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: notificationController,
      id: ControllerBuilders.notificationController,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: Container(
            margin: EdgeInsets.zero,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              bottom: false,
              child: TradeBitScaffold(
                isLoading: controller.isLoading,
                  appBar: PreferredSize(
                      preferredSize: Size.fromHeight(Dimensions.h_55),
                      child: Stack(
                    children: [
                      TradeBitAppBar(title: 'Notification',onTap: ()=> Navigator.pop(context)),
                      Positioned(
                          right: Dimensions.w_10,
                          top: Dimensions.h_18,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              controller.markAllRead();
                            },
                            child: TradeBitTextWidget(title: 'Mark all read',style: AppTextStyle.normalTextStyle(
                             FontSize.sp_14, AppColor.appColor
                                                  )),
                          ))
                    ],
                  )),
                  body: controller.notificationList.isEmpty ? Center(
                    child: TradeBitTextWidget(title: 'No Notifications yet',style: AppTextStyle.themeBoldNormalTextStyle(
                      fontSize: FontSize.sp_18,
                      color: Theme.of(context).highlightColor
                    )),
                  ) : RefreshIndicator(
                    onRefresh: () async {
                      controller.getNotifications(context);
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: Dimensions.h_15),
                        shrinkWrap: true,
                        itemCount: controller.notificationList.length,
                        controller: scrollController,
                        itemBuilder: (c,i) {
                          DateTime dateTime = DateTime.parse(controller.notificationList[i].createdAt.toString());
                          String formattedDate = DateFormat.yMMMMd().format(dateTime);
                          return Padding(
                            padding:  EdgeInsets.only(left: Dimensions.w_20,bottom: Dimensions.h_8,top: Dimensions.h_5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                     TradeBitContainer(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: controller.markRead ? Theme.of(context).shadowColor :AppColor.appColor
                                      ),
                                    ),
                                    HorizontalSpacing(width: Dimensions.w_10),
                                    TradeBitTextWidget(title: controller.notificationList[i].type?.toUpperCase() ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                        color: Theme.of(context).highlightColor,
                                        fontSize: FontSize.sp_12
                                    ))
                                  ],
                                ),
                                VerticalSpacing(height: Dimensions.h_10),
                                Padding(
                                  padding:  EdgeInsets.only(left: Dimensions.w_18),
                                  child: TradeBitTextWidget(title: controller.notificationList[i].content ?? '',
                                      style: AppTextStyle.normalTextStyle(FontSize.sp_11, Theme.of(context).shadowColor)),
                                ),
                                VerticalSpacing(height: Dimensions.h_8),
                                Padding(
                                  padding:  EdgeInsets.only(left: Dimensions.w_18),
                                  child: TradeBitTextWidget(title: formattedDate,
                                      style: AppTextStyle.normalTextStyle(FontSize.sp_11, Theme.of(context).shadowColor)),
                                ),
                                VerticalSpacing(height: Dimensions.h_5),
                              ],
                            ),
                          );
                        }, separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                    },),
                  )),
            ),
          ),
        );
      },

    );
  }
}
