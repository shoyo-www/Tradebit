import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit_controller.dart';
import 'package:tradebit_app/Presentation/Wallet/funding/funding.dart';
import 'package:tradebit_app/Presentation/Wallet/spot/spot.dart';
import 'package:tradebit_app/Presentation/Wallet/staking/staking.dart';
import 'package:tradebit_app/Presentation/Wallet/wallet_controller.dart';
import 'package:tradebit_app/Presentation/Wallet/wallet_screen.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final WalletController _controller = Get.put(WalletController());
  final DepositController controller = Get.put(DepositController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      id: ControllerBuilders.walletController,
      init: _controller,
      builder: (controller) {
        return TradeBitContainer(
          decoration: BoxDecoration(color: Theme
              .of(context)
              .cardColor),
          child: SafeArea(
            child: TradeBitScaffold(
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(Dimensions.h_50),
                    child: TradeBitContainer(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .cardColor
                      ),
                      height: Dimensions.h_40,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.isLoading ? null : controller
                                      .getIndex(index);
                                },
                                child: TradeBitContainer(
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: AppColor.transparent),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: Dimensions.w_10),
                                      child: Text(
                                          controller.categories[index],
                                          style: AppTextStyle
                                              .themeBoldNormalTextStyle(
                                              fontSize: controller
                                                  .selectedCategoryIndex ==
                                                  index
                                                  ? FontSize.sp_20
                                                  : FontSize.sp_16,
                                              color: controller
                                                  .selectedCategoryIndex ==
                                                  index ? Theme
                                                  .of(context)
                                                  .highlightColor : Theme
                                                  .of(context)
                                                  .shadowColor
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
                    )),
                body: callPage(controller.selectedCategoryIndex, controller)),
          ),
        );
      },
    );
  }
}

Widget callPage(int index,WalletController controller) {
  switch (index) {
    case 0:
      return  WalletScreen(controller: controller);

    case 1:
      return  Spot(controller: controller);

    case 2:
      return  Funding(controller: controller);

    case 3:
      return StakingScreen(controller: controller);

    default:
      return WalletScreen(controller: controller);
  }
}