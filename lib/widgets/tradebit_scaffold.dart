import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/images.dart';

class TradeBitScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final Color? safeAreaColor;
  final PreferredSizeWidget? appBar;
  final bool extendBodyBehindAppBar;
  final bool isLoading;
  final Widget? floatingActionButton;
  final  Future<bool> Function()? onWillPop;

  const TradeBitScaffold(
      {Key? key,
        required this.body,
        this.backgroundColor,
        this.bottomNavigationBar,
        this.drawer,
        this.appBar,
        this.safeAreaColor,
        this.endDrawer,
        this.extendBodyBehindAppBar = false,
        this.isLoading = false,
        this.onWillPop,
       this.floatingActionButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlayLoaderWithAppIcon(
      borderRadius: 8,
      appIconSize: 50,
      overlayOpacity: 0.5,
      overlayBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      circularProgressColor: AppColor.appColor,
      isLoading: isLoading,
      appIcon: Image.asset(Images.appIcon),
      child: WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            endDrawerEnableOpenDragGesture: false,
            drawerEnableOpenDragGesture: false,
            endDrawer: endDrawer,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            resizeToAvoidBottomInset: true,
            appBar: appBar,
            body: body,
            bottomNavigationBar: bottomNavigationBar,
            drawer: drawer,
            backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            extendBody: true,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
        ),
      ),
    );
  }
}
