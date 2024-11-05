import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:tradebit_app/Presentation/Auth/login/login.dart';
import 'package:tradebit_app/Presentation/Homepage/homepage.dart';
import 'package:tradebit_app/Presentation/Market/market.dart';
import 'package:tradebit_app/Presentation/Wallet/wallet.dart';
import 'package:tradebit_app/Presentation/exchange/exchange.dart';
import 'package:tradebit_app/Presentation/staking/staking.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';

class DashBoard extends StatefulWidget {
  int? index;

  DashBoard({super.key,this.index});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with WidgetsBindingObserver {
 int selectedIndex = 0;
 List<Widget> pages = [];

  onPage(int index) {
      selectedIndex = index;
      HapticFeedback.vibrate();
      setState(() {});
  }

  @override
  void initState() {
  selectedIndex = widget.index ?? 0;
  pages = [
    const HomePage(),
    const Market(),
    const Exchange(),
    LocalStorage.getBool(GetXStorageConstants.userLogin) == true
    ? const Login() : const Wallet(),
    const Staking(),
  ];
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
    Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
        if(Platform.isAndroid) {
          if(selectedIndex == 0) {
            MoveToBackground.moveTaskToBack();
          } else  {
            pushReplacementWithSlideTransition(context, DashBoard(index: 0));
          }
      }
        return false;
        },
        child: Stack(
          children: [
            TradeBitScaffold(
                body: LocalStorage.getBool(GetXStorageConstants.userLogin) == true && selectedIndex == 3 ? const Login() : IndexedStack(
                  index: selectedIndex,
                  children: pages,
                ),
                bottomNavigationBar: LocalStorage.getBool(GetXStorageConstants.userLogin) == true && selectedIndex == 3 ? const SizedBox() :
                Theme(
                  data: ThemeData(
                    splashColor: Theme.of(context).cardColor,
                    highlightColor: Theme.of(context).cardColor,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.only(top: 4),color: Theme.of(context).cardColor,
                        child: BottomNavigationBar(
                          selectedLabelStyle: AppTextStyle.normalTextStyle(
                              FontSize.sp_12,AppColor.appColor
                          ),
                          unselectedLabelStyle: AppTextStyle.normalTextStyle(
                              FontSize.sp_12,AppColor.appColor),
                          elevation: 0,
                          type: BottomNavigationBarType.fixed,
                          backgroundColor: Theme.of(context).cardColor,
                          selectedItemColor: AppColor.appColor,
                          currentIndex: selectedIndex,
                          unselectedItemColor: Theme.of(context).highlightColor,
                          selectedFontSize: FontSize.sp_10,
                          unselectedFontSize: FontSize.sp_10,
                          iconSize: Dimensions.h_15,
                          onTap: (value) {
                            selectedIndex = value;
                            setState(() {});
                          },
                          items:  [
                            BottomNavigationBarItem(
                                label: "Home",
                                icon: Icon(CupertinoIcons.house,size: Dimensions.h_15,color: selectedIndex == 0 ? AppColor.appColor : AppColor.greyColor)
                            ),
                            BottomNavigationBarItem(
                                label: 'Market',
                                icon: Icon(CupertinoIcons.chart_bar_alt_fill,size: Dimensions.h_15, color: selectedIndex == 1 ? AppColor.appColor : AppColor.greyColor)
                            ),
                            BottomNavigationBarItem(
                                label: 'Trade',
                                icon: Icon(CupertinoIcons.arrow_right_arrow_left,size: Dimensions.h_15,color: selectedIndex == 2 ? AppColor.appColor : AppColor.greyColor)
                            ),
                            BottomNavigationBarItem(
                                label: 'Wallet',
                                icon: FaIcon(FontAwesomeIcons.wallet,size: Dimensions.h_15,color: selectedIndex == 3 ? AppColor.appColor : AppColor.greyColor)
                            ),
                            BottomNavigationBarItem(
                                label: 'Staking',
                                icon: FaIcon(FontAwesomeIcons.seedling,size: Dimensions.h_15,color: selectedIndex == 4 ? AppColor.appColor : AppColor.greyColor)
                            ),
                          ],
                        ),
                      ),
                      TradeBitContainer(
                        height: 0.8,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.6)
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      );
    }
}

void pushReplacementWithSlideTransition(BuildContext context, Widget newPage,
    {bool isBack = false}) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500), // Adjust the duration as needed
      pageBuilder: (context, animation, secondaryAnimation) => newPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = isBack ?  const Offset(-1.0, 0.0): const Offset(1.0, 0.0); // Start the animation from the right
        var end = Offset.zero;
        var curve = Curves.easeInOutCubic;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}

void pushWithSlideTransition(BuildContext context, Widget newPage) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500), // Adjust the duration as needed
      pageBuilder: (context, animation, secondaryAnimation) => newPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0); // Start the animation from the right
        var end = Offset.zero;
        var curve = Curves.easeInOutCubic;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}