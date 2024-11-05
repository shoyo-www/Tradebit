import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/myfees/fees_controller.dart';
import 'package:tradebit_app/Presentation/ticket/create_ticket.dart';
import 'package:tradebit_app/Presentation/ticket/ticket_support_screen.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({super.key});

  @override
  State<MyTickets> createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  TicketController ticketController = Get.put(TicketController());

  @override
  void initState() {
    super.initState();
    ticketController.getTicket(context);
    ticketController.getTickets(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: TradeBitContainer(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor
          ),
          child: SafeArea(
            child: GetBuilder(
                id: ControllerBuilders.ticketController,
                init: ticketController,
                builder: (controller) {
                  return TradeBitScaffold(
                    isLoading: controller.isLoading,
                    appBar: PreferredSize(
                        preferredSize: Size.fromHeight(Dimensions.h_40),
                        child:  TradeBitAppBar(title: 'Support Ticket',onTap: ()=> Navigator.pop(context))),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: Dimensions.w_10, right: Dimensions.w_10),
                        child: Column(
                          children: [
                            VerticalSpacing(height: Dimensions.h_30),
                            TradeBitContainer(
                              height: Dimensions.h_120,
                              padding: EdgeInsets.only(left: Dimensions.w_10,
                                  right: Dimensions.w_10,
                                  top: Dimensions.h_35),
                              decoration: BoxDecoration(
                                  color: Theme
                                      .of(context)
                                      .cardColor,
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      TradeBitTextWidget(title: controller.totalTickets.toString(),
                                          style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_30,
                                              color: AppColor.appColor
                                          )),
                                      TradeBitTextWidget(title: 'Total Tickets',
                                          style: AppTextStyle.normalTextStyle(
                                              FontSize.sp_14, AppColor.appColor))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      TradeBitTextWidget(title: controller.inProcess.toString(),
                                          style: AppTextStyle
                                              .themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_30,
                                              color: Theme
                                                  .of(context)
                                                  .highlightColor
                                          )),
                                      TradeBitTextWidget(title: 'In Process',
                                          style: AppTextStyle.normalTextStyle(
                                              FontSize.sp_14, Theme
                                              .of(context)
                                              .highlightColor))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      TradeBitTextWidget(title: controller.closed.toString(),
                                          style: AppTextStyle
                                              .themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_30,
                                              color: Theme
                                                  .of(context)
                                                  .highlightColor
                                          )),
                                      TradeBitTextWidget(title: 'Closed Tickets',
                                          style: AppTextStyle.normalTextStyle(
                                              FontSize.sp_14, Theme
                                              .of(context)
                                              .highlightColor))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VerticalSpacing(height: Dimensions.h_15),
                            TradeBitContainer(
                              height: Dimensions.h_400,
                              padding: EdgeInsets.only(
                                  left: Dimensions.w_10, right: Dimensions.w_10),
                              decoration: BoxDecoration(
                                  color: Theme
                                      .of(context)
                                      .cardColor,
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              child: Column(
                                children: [
                                  VerticalSpacing(height: Dimensions.h_15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: ()=> pushWithSlideTransition(context, const TicketCreateScreen()),
                                        child: TradeBitContainer(
                                          padding: EdgeInsets.only(
                                              top: Dimensions.h_8,
                                              bottom: Dimensions.h_8,
                                              left: Dimensions.w_15,
                                              right: Dimensions.w_15),
                                          decoration: BoxDecoration(
                                              color: AppColor.appColor,
                                              borderRadius: BorderRadius.circular(6)
                                          ),
                                          child: Center(child: TradeBitTextWidget(
                                              title: 'New Ticket',
                                              style: AppTextStyle
                                                  .themeBoldNormalTextStyle(
                                                  fontSize: FontSize.sp_15,
                                                  color: AppColor.white))),
                                        ),
                                      )
                                    ],
                                  ),
                                  VerticalSpacing(height: Dimensions.h_10),
                                  Expanded(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          showBottomBorder: false,
                                          horizontalMargin: 0,
                                          dividerThickness: 0.00,
                                          columns: [
                                            // DataColumn(
                                            //   label: TradeBitTextWidget(
                                            //     title: '#',
                                            //     style: AppTextStyle
                                            //         .themeBoldNormalTextStyle(
                                            //         fontSize: FontSize.sp_12,
                                            //         color: Theme
                                            //             .of(context)
                                            //             .shadowColor
                                            //     ),),
                                            // ),
                                            DataColumn(
                                              label: TradeBitTextWidget(
                                                title: 'Ticket Type',
                                                style: AppTextStyle
                                                    .themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_12,
                                                    color: Theme
                                                        .of(context)
                                                        .shadowColor
                                                ),),
                                            ),
                                            DataColumn(
                                              label: TradeBitTextWidget(
                                                title: 'Subject',
                                                style: AppTextStyle
                                                    .themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_12,
                                                    color: Theme
                                                        .of(context)
                                                        .shadowColor
                                                ),),
                                            ),
                                            DataColumn(
                                              label: TradeBitTextWidget(
                                                title: 'Name',
                                                style: AppTextStyle
                                                    .themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_12,
                                                    color: Theme
                                                        .of(context)
                                                        .shadowColor
                                                ),),
                                            ),
                                            DataColumn(
                                              label: TradeBitTextWidget(
                                                title: 'Email',
                                                style: AppTextStyle
                                                    .themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_12,
                                                    color: Theme
                                                        .of(context)
                                                        .shadowColor),
                                              ),
                                            ),
                                            DataColumn(
                                              label: TradeBitTextWidget(
                                                title: 'Created At',
                                                style: AppTextStyle
                                                    .themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_12,
                                                    color: Theme
                                                        .of(context)
                                                        .shadowColor
                                                ),),
                                            ),
                                            DataColumn(
                                                label: TradeBitTextWidget(
                                                  title: 'Status',
                                                  style: AppTextStyle
                                                      .themeBoldNormalTextStyle(
                                                      fontSize: FontSize.sp_12,
                                                      color: Theme
                                                          .of(context)
                                                          .shadowColor
                                                  ))
                                            ),
                                            DataColumn(
                                                label: TradeBitTextWidget(
                                                    title: 'Action',
                                                    style: AppTextStyle
                                                        .themeBoldNormalTextStyle(
                                                        fontSize: FontSize.sp_12,
                                                        color: Theme
                                                            .of(context)
                                                            .shadowColor
                                                    ))
                                            ),
                                          ],
                                          rows: controller.ticket.map((e) =>
                                              DataRow(
                                                  cells: [
                                                    DataCell(
                                                      TradeBitTextWidget(
                                                          title: "${e.category?.name}",
                                                          style: AppTextStyle
                                                              .normalTextStyle(
                                                              FontSize.sp_13, Theme
                                                              .of(context)
                                                              .highlightColor)),
                                                    ),
                                                    DataCell(
                                                      TradeBitTextWidget(
                                                          title: "${e.title}",
                                                          style: AppTextStyle
                                                              .normalTextStyle(
                                                              FontSize.sp_13, Theme
                                                              .of(context)
                                                              .highlightColor)),
                                                    ),
                                                    DataCell(
                                                      TradeBitTextWidget(
                                                          title:
                                                              e.authorName ?? '',
                                                          style: AppTextStyle
                                                              .normalTextStyle(
                                                              FontSize.sp_13, Theme
                                                              .of(context)
                                                              .highlightColor)),
                                                    ),
                                                    DataCell(
                                                      TradeBitTextWidget(
                                                          title:
                                                              e.authorEmail ?? '',
                                                          style: AppTextStyle
                                                              .normalTextStyle(
                                                              FontSize.sp_13, Theme
                                                              .of(context)
                                                              .highlightColor)),
                                                    ),
                                                    DataCell(
                                                      TradeBitTextWidget(
                                                          title: e.createdAt.toString(),
                                                          style: AppTextStyle
                                                              .normalTextStyle(
                                                              FontSize.sp_13, Theme
                                                              .of(context)
                                                              .highlightColor)),
                                                    ),
                                                    DataCell(
                                                      TradeBitTextWidget(
                                                          title: "${e.status}",
                                                          style: AppTextStyle
                                                              .normalTextStyle(
                                                              FontSize.sp_13,
                                                              e.status == 'open'
                                                                  ? Colors.green
                                                                  : Colors.red)),
                                                    ),
                                                    DataCell(
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(context, MaterialPageRoute(builder: (c)=>
                                                              TicketSupportScreen(cId: int.parse(e.categoryId.toString()),
                                                                tID: int.parse(e.id.toString()),)));
                                                        },
                                                        child: TradeBitTextWidget(
                                                            title: "chat",
                                                            style: AppTextStyle
                                                                .normalTextStyle(
                                                                FontSize.sp_13,
                                                                AppColor.green)),
                                                      ),
                                                    ),
                                                  ]))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                      ),
                    ),
                  );
                }),
          )),
    );
  }
  @override
  void dispose() {
   Get.delete<TicketController>();
    super.dispose();
  }
}


class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}