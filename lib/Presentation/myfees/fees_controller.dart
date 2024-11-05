import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/ticket/my_tickets.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/tickets_repository_impl.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/create_ticket.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/ticket_send.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/ticket_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/ticket_support.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/ticketrespone.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class TicketController extends GetxController {
  bool isLoading = false;
  bool buttonLoading = false;
  List<TicketType> ticketList = [];
  int? totalTickets = 0 ;
  int? inProcess = 0;
  int? closed = 0;
  String? category;
  TextEditingController chatController = TextEditingController();
  TextEditingController subController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ticketDesController = TextEditingController();
  List<Ticket> ticket = [];
  List<Comment> comments = [];
  GlobalKey<FormState> ticketKey = GlobalKey<FormState>();
  final TicketsRepositoryImpl _ticketsRepositoryImpl = TicketsRepositoryImpl();


  getBack(BuildContext context) {
    nameController.clear();
    emailController.clear();
    ticketDesController.clear();
    subController.clear();
    Navigator.pop(context);
  }
  getTickets(BuildContext context) async {
    isLoading = true;
    var data = await _ticketsRepositoryImpl.ticketsType();
    data.fold((l) {
      if(l is ServerFailure) {
        isLoading = false;
        update([ControllerBuilders.ticketController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        isLoading = false;
        ticketList.clear();
        ticketList.addAll(r.data ?? []);
        category = ticketList[0].name;
        update([ControllerBuilders.ticketController]);
      }
      else {
        isLoading = false;
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.ticketController]);
  }

  getTicket(BuildContext context) async {
    isLoading = true;
    var data = await _ticketsRepositoryImpl.tickets();
    data.fold((l) {
      if(l is ServerFailure) {
        isLoading = false;
        update([ControllerBuilders.ticketController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        isLoading = false;
        ticket.clear();
        ticket.addAll(r.data?.tickets ?? []);
        totalTickets = r.data?.totalTickets ?? 0;
         inProcess= r.data?.totalInprocess ?? 0;
         closed = r.data?.totalClose ?? 0;
        update([ControllerBuilders.ticketController]);
      }
      else {
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.ticketController]);
  }

  getTicketSupport(BuildContext context,int id) async {
    isLoading = true;
    var data = await _ticketsRepositoryImpl.ticketSupport(id);
    data.fold((l) {
      if(l is ServerFailure) {
        isLoading = false;
        update([ControllerBuilders.ticketController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        isLoading = false;
        comments.clear();
        comments.addAll(r.data?.comments ?? []);
        update([ControllerBuilders.ticketController]);
      }
      else {
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.ticketController]);
  }

  createTicket(BuildContext context,int categoryId,int ticketId) async {
    buttonLoading = true;
    var req = TicketSendRequest(
      categoryId: categoryId,
      comment: chatController.text,
      ticketId: ticketId
    );
    var data = await _ticketsRepositoryImpl.ticketSend(req);
    data.fold((l) {
      if(l is ServerFailure) {
        buttonLoading = false;
        update([ControllerBuilders.ticketController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        chatController.clear();
        buttonLoading = false;
        getTicketSupport(context,ticketId);
        update([ControllerBuilders.ticketController]);
      }
      else {
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.ticketController]);
  }

  ticketCreate(BuildContext context) async {
    if(ticketKey.currentState!.validate()) {
      buttonLoading = true;
      update([ControllerBuilders.ticketController]);
      var req = CreateTicket(
          categoryId: category == 'Account' ? 0 : category == "Trading" ? 1 : 3,
          title: subController.text,
          authorEmail: emailController.text,
          authorName: nameController.text,
          content: ticketDesController.text
      );
      var data = await _ticketsRepositoryImpl.createTicket(req);
      data.fold((l) {
        if(l is ServerFailure) {
          buttonLoading = false;
          update([ControllerBuilders.ticketController]);
          ToastUtils.showCustomToast(context, l.message ?? '', false);
        }
      }, (r) {
        String code = r.statusCode ?? '';
        if(code == '1' ) {
          buttonLoading = false;
          ToastUtils.showCustomToast(context, r.message ?? '', true);
          getTicket(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const MyTickets()));
          subController.clear();
          emailController.clear();
          nameController.clear();
          ticketDesController.clear();
          update([ControllerBuilders.ticketController]);
        }
        else {
          buttonLoading = false;
          ToastUtils.showCustomToast(context, r.message ?? '', false);
          update([ControllerBuilders.ticketController]);
        }
      });
      update([ControllerBuilders.ticketController]);
    }

  }

  void showBottomSheetDeposit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: AppColor.transparent,
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                minChildSize: 0.2,
                maxChildSize: 0.75,
                builder: (_, controller) {
                  return Container(
                    padding: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpacing(height: Dimensions.h_15),
                        Expanded(
                          child: ListView.separated(
                            controller: controller,
                            itemCount: ticketList.length ?? 0,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onTap: () {
                                  category = ticketList[index].name;
                                  update([ControllerBuilders.ticketController]);
                                  Navigator.pop(context);
                                },
                                child: TradeBitContainer(
                                    margin: const EdgeInsets.only(top: 5,bottom: 5,left: 5,right: 5),
                                    height: Dimensions.h_35,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Align(
                                        alignment: Alignment.centerLeft ,
                                        child: Text(ticketList[index].name ?? ''))),
                              );
                            }, separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}