import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/exchange/exhange_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/listWidget.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';

class ExchangeDrawer extends StatefulWidget {
  final ExchangeController controller;
  const ExchangeDrawer({Key? key, required this.controller}) : super(key: key);

  @override
  State<ExchangeDrawer> createState() => _ExchangeDrawerState();
}

class _ExchangeDrawerState extends State<ExchangeDrawer> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  List <String> marketFamily = ['USDT','BTC','ETH','TBC','TRX'];

  @override
  void initState()  {
    super.initState();
      widget.controller.connectToMarketSocketNew();
    _tabController = TabController(length: marketFamily.length,vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      init: widget.controller,
      id: ControllerBuilders.exchangeController,
      builder: (controller) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: TradeBitScaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalSpacing(height: Dimensions.h_15),
                  Padding(
                    padding:  EdgeInsets.only(top: Dimensions.h_15, left: Dimensions.w_5, right: Dimensions.w_5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          TabBar(
                            onTap: (int index)  {},
                            overlayColor:MaterialStateProperty.all<Color>(AppColor.transparent),
                            labelPadding: const EdgeInsets.only(left: 20,right: 20),
                            isScrollable: true,
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            indicator: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColor.appColor,
                                        width: 2
                                    )
                                )
                            ),
                            tabAlignment: TabAlignment.start,
                            labelColor: AppColor.appColor,
                            unselectedLabelColor: Theme.of(context).highlightColor,
                            unselectedLabelStyle: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor
                            ),
                            labelStyle: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor
                            ),
                            tabs: <Widget>[
                              for (int i = 0; i < marketFamily.length; i++)
                                Tab(
                                  child: Text(
                                    marketFamily[i].toString(),
                                    style: AppTextStyle.themeBoldNormalTextStyle(
                                        fontSize: FontSize.sp_14,
                                        color: Theme.of(context).highlightColor
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  VerticalSpacing(height: Dimensions.h_2),
                  Expanded(
                    child: Container(
                      margin:  EdgeInsets.only(left: Dimensions.h_10,right: Dimensions.h_10,bottom: Dimensions.h_10),
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: <Widget>[
                          ListWidget(listData: LocalStorage.getListCrypto(),disable: true, exchangeData:LocalStorage.getListCrypto(),exchangeController: widget.controller),
                          ListWidget(listData: LocalStorage.getListBtc(),disable: true,exchangeData: LocalStorage.getListBtc(),exchangeController: widget.controller),
                          ListWidget( listData: LocalStorage.getListEth(),disable: true,exchangeData: LocalStorage.getListEth(),exchangeController: widget.controller),
                          ListWidget(listData: LocalStorage.getListTbc(),disable: true,exchangeData: LocalStorage.getListTbc(),exchangeController: widget.controller),
                          ListWidget(listData: LocalStorage.getListTrx(),disable: true,exchangeData: LocalStorage.getListTrx(),exchangeController: widget.controller),

                        ],
                      ),
                    ),
                  ),
                ],
              )),
        );
      },

    );
  }

}
