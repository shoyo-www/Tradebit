import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tradebit_app/Presentation/Auth/login/login.dart';
import 'package:tradebit_app/Presentation/Homepage/home_controller.dart';
import 'package:tradebit_app/Presentation/Market/market_search.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit_screen.dart';
import 'package:tradebit_app/Presentation/Wallet/withdraw/withdraw_list.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/getx/internet_controller.dart';
import 'package:tradebit_app/Presentation/kyc_verfication/kyc_verfication.dart';
import 'package:tradebit_app/Presentation/launchpad/launchpad.dart';
import 'package:tradebit_app/Presentation/notification/notification.dart';
import 'package:tradebit_app/Presentation/refferal/Refferal.dart';
import 'package:tradebit_app/Presentation/sendToken/send_token.dart';
import 'package:tradebit_app/Presentation/setting/setting.dart';
import 'package:tradebit_app/Presentation/transfer/transfer.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/gainersStreamWidget.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/spot_streamWidget.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  late TabController _tabController;

  final List<String> dataList = [
    'Spot',
    'Top Gainers',
    'Top Losers',
  ];
  final List<String> cryptoList = [
    'USDT',
    'ETH',
    'BTC',
    'TBC',
    'TRX',
  ];
  List<MenuItem> menuList = [
    MenuItem(name: 'Withdraw', image: Images.withdrawImage),
    MenuItem(name: 'Deposit', image: Images.depositNew),
    MenuItem(name: 'Send Token', image: Images.send),
    MenuItem(name: 'Hold & Earn', image: Images.holdEarn),
  ];

  List<MenuItem> menuList2 = [
    MenuItem(name: 'Launchpad', image: Images.launchpad),
    MenuItem(name: 'Transfer', image: Images.transfer),
    MenuItem(name: 'Referral', image: Images.referral),
    MenuItem(name: 'Buy', image: Images.buy),
  ];

  final HomeController _controller = Get.put(HomeController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: dataList.length, vsync: this);
  }

  final internetController = Get.find<ConnectivityController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: _controller,
        id: ControllerBuilders.homeController,
        builder: (controller) {
          return TradeBitContainer(
            decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .cardColor
            ),
            child: SafeArea(
              child: TradeBitScaffold(
                isLoading: controller.cryptoLoading,
                key: _scaffoldKey,
                body: DefaultTabController(
                  length: 3,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          centerTitle: false,
                          title: Row(
                            children: [
                              Image.asset(Images.appIcon, scale: 8),
                              HorizontalSpacing(width: Dimensions.w_10),
                              GestureDetector(
                                onTap: () {
                                  LocalStorage.writeBool(
                                      GetXStorageConstants.searchFromHome,
                                      true);
                                  pushWithSlideTransition(
                                      context, const MarketSearchPage());
                                },
                                child: TradeBitContainer(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  height: Dimensions.h_30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Theme
                                          .of(context)
                                          .scaffoldBackgroundColor
                                  ),
                                  width: Dimensions.w_140,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      TradeBitTextWidget(title: 'MCOINUSDT',
                                          style: AppTextStyle.normalTextStyle(
                                              FontSize.sp_13, Theme
                                              .of(context)
                                              .shadowColor)),
                                      Icon(
                                        CupertinoIcons.search,
                                        size: 17,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            GestureDetector(
                                onTap: () {
                                  LocalStorage.getBool(
                                      GetXStorageConstants.userLogin) == true ?
                                  pushReplacementWithSlideTransition(
                                      context, const Login())
                                      : pushWithSlideTransition(
                                      context, const NotificationScreen());
                                },
                                child: SizedBox(
                                    height: Dimensions.h_20,
                                    width: Dimensions.h_20,
                                    child: Image.asset(
                                      Images.notification, scale: 2.6,))),
                            HorizontalSpacing(width: Dimensions.w_10),
                            // GestureDetector(
                            //     onTap: () {
                            //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const QRViewExample()));
                            //     },
                            //       child: SizedBox(
                            //           height: Dimensions.h_20,
                            //           width: Dimensions.h_20,
                            //           child: Image.asset(Images.qrScanner,scale: 2.6))),
                            HorizontalSpacing(width: Dimensions.w_10),
                            Padding(
                              padding: EdgeInsets.only(top: Dimensions.h_8),
                              child: GestureDetector(
                                onTap: () {
                                  LocalStorage.getBool(
                                      GetXStorageConstants.userLogin) == true
                                      ? LocalStorage.writeBool(
                                      GetXStorageConstants.loginFromHome, true)
                                      : null;
                                  LocalStorage.getBool(
                                      GetXStorageConstants.userLogin) == true
                                      ? pushReplacementWithSlideTransition(
                                      context, const Login())
                                      :
                                  pushWithSlideTransition(
                                      context, const Setting());
                                },
                                child: Stack(
                                  children: [
                                    TradeBitContainer(
                                        padding: const EdgeInsets.all(8),
                                        height: Dimensions.h_30,
                                        width: Dimensions.h_30,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme
                                                    .of(context)
                                                    .shadowColor
                                                    .withOpacity(0.2)
                                            ),
                                            shape: BoxShape.circle,
                                            color: Theme
                                                .of(context)
                                                .primaryColorDark
                                        ),
                                        child: Image.asset(
                                          Images.user, scale: 8,)),
                                    LocalStorage.getBool(
                                        GetXStorageConstants.userLogin) == false
                                        ? Positioned(
                                        right: 0,
                                        child: TradeBitContainer(
                                            padding: const EdgeInsets.all(0),
                                            height: Dimensions.h_10,
                                            width: Dimensions.h_10,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green
                                            ),
                                            child: LocalStorage.getBool(
                                                GetXStorageConstants
                                                    .userLogin) == false
                                                ? const Icon(
                                              Icons.check, color: Colors.white,
                                              size: 8,)
                                                : const SizedBox()))
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                            HorizontalSpacing(width: Dimensions.w_10),
                          ],
                          automaticallyImplyLeading: false,
                          backgroundColor: Theme
                              .of(context)
                              .cardColor,
                        ),
                        SliverAppBar(
                          actions: const [
                            SizedBox(),
                          ],
                          backgroundColor: Theme
                              .of(context)
                              .scaffoldBackgroundColor,
                          automaticallyImplyLeading: false,
                          pinned: false,
                          expandedHeight: Dimensions.h_360,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Column(
                              children: [
                                TradeBitContainer(
                                  decoration: BoxDecoration(
                                      color: Theme
                                          .of(context)
                                          .cardColor
                                  ),
                                  child: Column(
                                    children: [
                                      CarouselSlider(
                                          items: LocalStorage.getList()
                                              .map((item) =>
                                              Image.network(item.image ?? '',
                                                fit: BoxFit.contain,
                                                width: 1000.0,
                                                loadingBuilder: (
                                                    BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      color: AppColor.appColor,
                                                      value: loadingProgress
                                                          .expectedTotalBytes !=
                                                          null
                                                          ?
                                                      loadingProgress
                                                          .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, url,
                                                    error) => const Icon(
                                                    Icons.error,
                                                    color: AppColor.red),))
                                              .toList(),
                                          options: CarouselOptions(
                                            viewportFraction: 1,
                                            autoPlay: true,
                                            aspectRatio: 3,
                                          )),
                                      VerticalSpacing(height: Dimensions.h_2),
                                      GestureDetector(
                                        onTap: () =>
                                            pushReplacementWithSlideTransition(context, DashBoard(index: 4)),
                                        child: Row(
                                          children: [
                                            HorizontalSpacing(
                                                width: Dimensions.w_10),
                                            Image.asset(
                                              Images.announcement, scale: 4,
                                              color: Theme
                                                  .of(context)
                                                  .highlightColor,),
                                            HorizontalSpacing(
                                                width: Dimensions.w_12),
                                            TradeBitTextWidget(
                                                title: 'Earn upto \$50 on minimum stake of 1000 MCOIN ...',
                                                style: AppTextStyle
                                                    .normalTextStyle(
                                                    FontSize.sp_12, Theme
                                                    .of(context)
                                                    .highlightColor
                                                    .withOpacity(0.5))),
                                            const Spacer(),
                                            Icon(
                                                Icons.arrow_forward_ios,
                                                color: Theme
                                                    .of(context)
                                                    .shadowColor,
                                                size: Dimensions.h_12),
                                            HorizontalSpacing(
                                                width: Dimensions.w_15),
                                          ],
                                        ),
                                      ),
                                      VerticalSpacing(height: Dimensions.h_5)
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: Dimensions.h_1),
                                  color: Theme
                                      .of(context)
                                      .scaffoldBackgroundColor,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: Dimensions.h_70,
                                            width: MediaQuery
                                                .sizeOf(context)
                                                .width / 1.1,
                                            child: PageView(
                                              controller: controller
                                                  .pageController,
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                SizedBox(
                                                  height: Dimensions.h_70,
                                                  child: ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      scrollDirection: Axis
                                                          .horizontal,
                                                      shrinkWrap: true,
                                                      itemCount: menuList
                                                          .length,
                                                      itemBuilder: (c, i) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            if (menuList[i]
                                                                .name ==
                                                                "Send Token") {
                                                              LocalStorage
                                                                  .writeBool(
                                                                  GetXStorageConstants
                                                                      .transferFromHome,
                                                                  true);
                                                              LocalStorage
                                                                  .getBool(
                                                                  GetXStorageConstants
                                                                      .userLogin) ==
                                                                  true
                                                                  ? pushReplacementWithSlideTransition(
                                                                  context,
                                                                  const Login())
                                                                  : pushReplacementWithSlideTransition(
                                                                  context,
                                                                  const Transfer());
                                                            } else
                                                            if (menuList[i]
                                                                .name ==
                                                                'Deposit') {
                                                              LocalStorage
                                                                  .writeBool(
                                                                  GetXStorageConstants
                                                                      .depositFromHome,
                                                                  true);
                                                              LocalStorage
                                                                  .writeBool(
                                                                  GetXStorageConstants
                                                                      .fromExchange,
                                                                  false);
                                                              LocalStorage
                                                                  .getBool(
                                                                  GetXStorageConstants
                                                                      .userLogin) ==
                                                                  true ?
                                                              pushReplacementWithSlideTransition(
                                                                  context,
                                                                  const Login())
                                                                  : pushReplacementWithSlideTransition(
                                                                  context,
                                                                  const DepositScreen());
                                                            } else
                                                            if (menuList[i]
                                                                .name ==
                                                                "Withdraw") {
                                                              LocalStorage
                                                                  .writeBool(
                                                                  GetXStorageConstants
                                                                      .withdrawFromHome,
                                                                  true);
                                                              LocalStorage
                                                                  .writeBool(
                                                                  GetXStorageConstants
                                                                      .fromExchange,
                                                                  false);
                                                              LocalStorage
                                                                  .getBool(
                                                                  GetXStorageConstants
                                                                      .userLogin) ==
                                                                  true
                                                                  ?
                                                              pushReplacementWithSlideTransition(
                                                                  context,
                                                                  const Login())
                                                                  :
                                                              pushReplacementWithSlideTransition(
                                                                  context,
                                                                  const WithdrawList());
                                                            } else {
                                                              pushReplacementWithSlideTransition(
                                                                  context,
                                                                  DashBoard(
                                                                      index: 4));
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .only(
                                                                left: Dimensions
                                                                    .w_20,
                                                                top: Dimensions
                                                                    .h_10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                              children: [
                                                                TradeBitContainer(
                                                                  padding: EdgeInsets
                                                                      .all(
                                                                      Dimensions
                                                                          .h_6),
                                                                  height: Dimensions
                                                                      .h_35,
                                                                  width: Dimensions
                                                                      .h_35,
                                                                  decoration: BoxDecoration(
                                                                    color: Theme
                                                                        .of(
                                                                        context)
                                                                        .cardColor,
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        50),
                                                                  ),
                                                                  child: Image
                                                                      .asset(
                                                                      menuList[i]
                                                                          .image),
                                                                ),
                                                                VerticalSpacing(
                                                                    height: Dimensions
                                                                        .h_2),
                                                                TradeBitTextWidget(
                                                                    title: menuList[i]
                                                                        .name,
                                                                    style: AppTextStyle
                                                                        .themeBoldNormalTextStyle(
                                                                        fontSize: FontSize
                                                                            .sp_12,
                                                                        color: Theme
                                                                            .of(
                                                                            context)
                                                                            .shadowColor)),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                                SizedBox(
                                                  height: Dimensions.h_70,
                                                  child: ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      scrollDirection: Axis
                                                          .horizontal,
                                                      shrinkWrap: true,
                                                      itemCount: menuList2
                                                          .length,
                                                      itemBuilder: (c, i) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            if (menuList2[i]
                                                                .name ==
                                                                "Launchpad") {
                                                              pushWithSlideTransition(
                                                                  context,
                                                                  const LaunchPad());
                                                            } else
                                                            if (menuList2[i]
                                                                .name ==
                                                                'Transfer') {
                                                              LocalStorage
                                                                  .getBool(
                                                                  GetXStorageConstants
                                                                      .userLogin) ==
                                                                  true
                                                                  ?
                                                              pushReplacementWithSlideTransition(
                                                                  context,
                                                                  const Login())
                                                                  :
                                                              pushWithSlideTransition(
                                                                  context,
                                                                  const SendToken());
                                                            } else
                                                            if (menuList2[i]
                                                                .name ==
                                                                "Referral") {
                                                              LocalStorage
                                                                  .writeBool(
                                                                  'Referral',
                                                                  true);
                                                              LocalStorage
                                                                  .getBool(
                                                                  GetXStorageConstants
                                                                      .userLogin) ==
                                                                  true
                                                                  ?
                                                              pushReplacementWithSlideTransition(
                                                                  context,
                                                                  const Login())
                                                                  :
                                                              pushWithSlideTransition(
                                                                  context,
                                                                  const Refferal());
                                                            } else
                                                            if (menuList2[i]
                                                                .name ==
                                                                "Buy") {
                                                              pushReplacementWithSlideTransition(
                                                                  context,
                                                                  DashBoard(
                                                                      index: 2));
                                                            }
                                                            else {}
                                                          },
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .only(
                                                                left: Dimensions
                                                                    .w_25,
                                                                right: Dimensions
                                                                    .w_5,
                                                                top: Dimensions
                                                                    .h_15),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                              children: [
                                                                TradeBitContainer(
                                                                  padding: EdgeInsets
                                                                      .all(
                                                                      Dimensions
                                                                          .h_5),
                                                                  height: Dimensions
                                                                      .h_30,
                                                                  width: Dimensions
                                                                      .h_30,
                                                                  decoration: BoxDecoration(
                                                                    color: Theme
                                                                        .of(
                                                                        context)
                                                                        .cardColor,
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        50),
                                                                  ),
                                                                  child: Image
                                                                      .asset(
                                                                      menuList2[i]
                                                                          .image),
                                                                ),
                                                                VerticalSpacing(
                                                                    height: Dimensions
                                                                        .h_2),
                                                                TradeBitTextWidget(
                                                                    title: menuList2[i]
                                                                        .name,
                                                                    style: AppTextStyle
                                                                        .themeBoldNormalTextStyle(
                                                                        fontSize: FontSize
                                                                            .sp_12,
                                                                        color: Theme
                                                                            .of(
                                                                            context)
                                                                            .shadowColor)),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                          controller.pageButton
                                              ? GestureDetector(
                                              onTap: () {
                                                controller.onTappedBack(0);
                                              },
                                              child: TradeBitContainer(
                                                  margin: EdgeInsets.only(
                                                      top: Dimensions.h_10),
                                                  padding: const EdgeInsets.all(
                                                      5),
                                                  height: Dimensions.h_20,
                                                  width: Dimensions.h_20,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Theme
                                                              .of(context)
                                                              .shadowColor
                                                              .withOpacity(0.2)
                                                      ),
                                                      shape: BoxShape.circle,
                                                      color: Theme
                                                          .of(context)
                                                          .primaryColorDark
                                                  ),
                                                  child: const RotatedBox(
                                                      quarterTurns: 2,
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 10,))))
                                              :
                                          GestureDetector(
                                              onTap: () {
                                                controller.onTapped(1);
                                              },
                                              child: TradeBitContainer(
                                                  margin: EdgeInsets.only(
                                                      top: Dimensions.h_15),
                                                  padding: const EdgeInsets.all(
                                                      5),
                                                  height: Dimensions.h_20,
                                                  width: Dimensions.h_20,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Theme
                                                              .of(context)
                                                              .shadowColor
                                                              .withOpacity(0.2)
                                                      ),
                                                      shape: BoxShape.circle,
                                                      color: Theme
                                                          .of(context)
                                                          .primaryColorDark
                                                  ),
                                                  child: const Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 10,))),
                                        ],
                                      ),
                                      VerticalSpacing(height: Dimensions.h_13),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: Dimensions.w_8,
                                            right: Dimensions.w_8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery
                                                  .sizeOf(context)
                                                  .width / 2.2,
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      pushReplacementWithSlideTransition(
                                                          context, DashBoard(
                                                          index: 4));
                                                    },
                                                    child: TradeBitContainer(
                                                      margin: EdgeInsets.zero,
                                                      padding: EdgeInsets.only(
                                                          left: Dimensions.w_5,
                                                          top: Dimensions.h_10,
                                                          bottom: Dimensions
                                                              .h_10),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Theme
                                                                  .of(context)
                                                                  .shadowColor
                                                                  .withOpacity(
                                                                  0.2)),
                                                          borderRadius: BorderRadius
                                                              .circular(12),
                                                          color: Theme
                                                              .of(context)
                                                              .cardColor
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          HorizontalSpacing(
                                                              width: Dimensions
                                                                  .w_10),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              TradeBitTextWidget(
                                                                title: 'Hold & Earn',
                                                                style: AppTextStyle
                                                                    .themeBoldNormalTextStyle(
                                                                    fontSize: FontSize
                                                                        .sp_13,
                                                                    color: Theme
                                                                        .of(
                                                                        context)
                                                                        .highlightColor
                                                                ),),
                                                              const VerticalSpacing(
                                                                  height: 3),
                                                              TradeBitTextWidget(
                                                                title: 'Get upto 50% APY',
                                                                style: AppTextStyle
                                                                    .normalTextStyle(
                                                                    FontSize
                                                                        .sp_11,
                                                                    Theme
                                                                        .of(
                                                                        context)
                                                                        .shadowColor
                                                                ),),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .only(top: 0.0),
                                                            child: TradeBitContainer(
                                                                padding: const EdgeInsets
                                                                    .all(5),
                                                                height: Dimensions
                                                                    .h_20,
                                                                width: Dimensions
                                                                    .h_20,
                                                                decoration: BoxDecoration(
                                                                    border: Border
                                                                        .all(
                                                                        color: Theme
                                                                            .of(
                                                                            context)
                                                                            .shadowColor
                                                                            .withOpacity(
                                                                            0.2)
                                                                    ),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Theme
                                                                        .of(
                                                                        context)
                                                                        .primaryColorDark
                                                                ),
                                                                child: const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 10,)),
                                                          ),
                                                          HorizontalSpacing(
                                                              width: Dimensions
                                                                  .w_10),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  VerticalSpacing(
                                                      height: Dimensions.h_10),
                                                  LocalStorage.getBool(
                                                      GetXStorageConstants
                                                          .userLogin) == true
                                                      ? GestureDetector(
                                                    onTap: () {
                                                      pushReplacementWithSlideTransition(
                                                          context,
                                                          const Login());
                                                    },
                                                    child: TradeBitContainer(
                                                      margin: EdgeInsets.zero,
                                                      padding: EdgeInsets.only(
                                                          left: Dimensions.w_5,
                                                          top: Dimensions.h_10,
                                                          bottom: Dimensions
                                                              .h_15),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(12),
                                                        color: AppColor
                                                            .appColor,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          HorizontalSpacing(
                                                              width: Dimensions
                                                                  .w_10),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              TradeBitTextWidget(
                                                                title: 'Login/Signup',
                                                                style: AppTextStyle
                                                                    .themeBoldNormalTextStyle(
                                                                    fontSize: FontSize
                                                                        .sp_14,
                                                                    color: AppColor
                                                                        .white
                                                                ),),
                                                              const VerticalSpacing(
                                                                  height: 4),
                                                              TradeBitTextWidget(
                                                                title: 'Access your account',
                                                                style: AppTextStyle
                                                                    .normalTextStyle(
                                                                    FontSize
                                                                        .sp_11,
                                                                    AppColor
                                                                        .white
                                                                ),),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .only(top: 5.0),
                                                            child: TradeBitContainer(
                                                                padding: const EdgeInsets
                                                                    .all(5),
                                                                height: Dimensions
                                                                    .h_20,
                                                                width: Dimensions
                                                                    .h_20,
                                                                decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                      color: AppColor
                                                                          .white
                                                                  ),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 10,
                                                                  color: AppColor
                                                                      .white,)),
                                                          ),
                                                          HorizontalSpacing(
                                                              width: Dimensions
                                                                  .w_10),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                      :
                                                  GestureDetector(
                                                    onTap: () =>
                                                        pushReplacementWithSlideTransition(
                                                            context, DashBoard(
                                                            index: 2)),
                                                    child: TradeBitContainer(
                                                      margin: EdgeInsets.zero,
                                                      padding: EdgeInsets.only(
                                                          left: Dimensions.w_5,
                                                          top: Dimensions.h_10,
                                                          bottom: Dimensions
                                                              .h_15),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Theme
                                                                  .of(context)
                                                                  .shadowColor
                                                                  .withOpacity(
                                                                  0.2)
                                                          ),
                                                          borderRadius: BorderRadius
                                                              .circular(12),
                                                          color: Theme
                                                              .of(context)
                                                              .cardColor
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          HorizontalSpacing(
                                                              width: Dimensions
                                                                  .w_10),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              TradeBitTextWidget(
                                                                title: 'Buy Crypto',
                                                                style: AppTextStyle
                                                                    .themeBoldNormalTextStyle(
                                                                    fontSize: FontSize
                                                                        .sp_13,
                                                                    color: Theme
                                                                        .of(
                                                                        context)
                                                                        .highlightColor
                                                                ),),
                                                              const VerticalSpacing(
                                                                  height: 4),
                                                              TradeBitTextWidget(
                                                                title: 'Credit / Debit card',
                                                                style: AppTextStyle
                                                                    .normalTextStyle(
                                                                    FontSize
                                                                        .sp_11,
                                                                    Theme
                                                                        .of(
                                                                        context)
                                                                        .shadowColor
                                                                ),),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .only(top: 5.0),
                                                            child: TradeBitContainer(
                                                                padding: const EdgeInsets
                                                                    .all(5),
                                                                height: Dimensions
                                                                    .h_20,
                                                                width: Dimensions
                                                                    .h_20,
                                                                decoration: BoxDecoration(
                                                                    border: Border
                                                                        .all(
                                                                        color: Theme
                                                                            .of(
                                                                            context)
                                                                            .shadowColor
                                                                            .withOpacity(
                                                                            0.2)
                                                                    ),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Theme
                                                                        .of(
                                                                        context)
                                                                        .primaryColorDark
                                                                ),
                                                                child: const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 10,)),
                                                          ),
                                                          HorizontalSpacing(
                                                              width: Dimensions
                                                                  .w_10),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            controller.profile?.userKycStatus ==
                                                "new" || controller.profile
                                                ?.userKycStatus == 'rejected' ?
                                            GestureDetector(
                                              onTap: () {
                                                pushReplacementWithSlideTransition(
                                                    context,
                                                    const KycVerification());
                                              },
                                              child: SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width / 2.1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    TradeBitContainer(
                                                      margin: EdgeInsets.zero,
                                                      height: Dimensions.h_110,
                                                      padding: EdgeInsets.only(
                                                          left: Dimensions.w_5,
                                                          top: Dimensions.h_5,
                                                          bottom: 2),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Theme
                                                                  .of(context)
                                                                  .shadowColor
                                                                  .withOpacity(
                                                                  0.2)),
                                                          color: Theme
                                                              .of(context)
                                                              .cardColor,
                                                          borderRadius: BorderRadius
                                                              .circular(12),
                                                          image: const DecorationImage(
                                                              image: AssetImage(
                                                                  Images
                                                                      .kycImage),
                                                              fit: BoxFit
                                                                  .contain,
                                                              alignment: Alignment
                                                                  .bottomCenter)
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          HorizontalSpacing(
                                                              width: Dimensions
                                                                  .w_10),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              const VerticalSpacing(
                                                                  height: 10),
                                                              TradeBitTextWidget(
                                                                title: 'Kyc Completion',
                                                                style: AppTextStyle
                                                                    .themeBoldNormalTextStyle(
                                                                    fontSize: FontSize
                                                                        .sp_13,
                                                                    color: Theme
                                                                        .of(
                                                                        context)
                                                                        .highlightColor
                                                                ),),
                                                              const VerticalSpacing(
                                                                  height: 10),
                                                              TradeBitTextWidget(
                                                                title: 'Complete your Kyc to\nunlock new features',
                                                                style: AppTextStyle
                                                                    .normalTextStyle(
                                                                    FontSize
                                                                        .sp_11,
                                                                    Theme
                                                                        .of(
                                                                        context)
                                                                        .shadowColor
                                                                ),),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                top: 15.0),
                                                            child: Align(
                                                                alignment: Alignment
                                                                    .topRight,
                                                                child: TradeBitContainer(
                                                                    padding: const EdgeInsets
                                                                        .all(5),
                                                                    height: Dimensions
                                                                        .h_20,
                                                                    width: Dimensions
                                                                        .h_20,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Theme
                                                                            .of(
                                                                            context)
                                                                            .indicatorColor,
                                                                        border: Border
                                                                            .all(
                                                                            color: Theme
                                                                                .of(
                                                                                context)
                                                                                .shadowColor
                                                                                .withOpacity(
                                                                                0.2))
                                                                    ),
                                                                    child: const Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      size: 10,))),
                                                          ),
                                                          HorizontalSpacing(
                                                              width: Dimensions
                                                                  .w_10),
                                                        ],
                                                      ),
                                                    ),
                                                    VerticalSpacing(
                                                        height: Dimensions.h_8),
                                                  ],
                                                ),
                                              ),
                                            ) : GestureDetector(
                                              onTap: () {
                                                pushReplacementWithSlideTransition(
                                                    context,
                                                    DashBoard(index: 4));
                                              },
                                              child: SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width / 2.1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    TradeBitContainer(
                                                      margin: EdgeInsets.zero,
                                                      height: Dimensions.h_125,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Theme
                                                                .of(context)
                                                                .shadowColor
                                                                .withOpacity(
                                                                0.2)),
                                                        color: Theme
                                                            .of(context)
                                                            .cardColor,
                                                        borderRadius: BorderRadius
                                                            .circular(12),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              HorizontalSpacing(
                                                                  width: Dimensions
                                                                      .w_10),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  VerticalSpacing(
                                                                      height: Dimensions
                                                                          .h_12),
                                                                  TradeBitTextWidget(
                                                                    title: 'MCOIN',
                                                                    style: AppTextStyle
                                                                        .themeBoldNormalTextStyle(
                                                                        fontSize: FontSize
                                                                            .sp_15,
                                                                        color: Theme
                                                                            .of(
                                                                            context)
                                                                            .highlightColor
                                                                    ),),
                                                                  VerticalSpacing(
                                                                      height: Dimensions
                                                                          .h_12),
                                                                ],
                                                              ),
                                                              const Spacer(),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    top: Dimensions
                                                                        .h_5),
                                                                child: Align(
                                                                    alignment: Alignment
                                                                        .topRight,
                                                                    child: TradeBitContainer(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            5),
                                                                        height: Dimensions
                                                                            .h_20,
                                                                        width: Dimensions
                                                                            .h_20,
                                                                        decoration: BoxDecoration(
                                                                            shape: BoxShape
                                                                                .circle,
                                                                            color: Theme
                                                                                .of(
                                                                                context)
                                                                                .indicatorColor,
                                                                            border: Border
                                                                                .all(
                                                                                color: Theme
                                                                                    .of(
                                                                                    context)
                                                                                    .shadowColor
                                                                                    .withOpacity(
                                                                                    0.2))
                                                                        ),
                                                                        child: const Icon(
                                                                          Icons
                                                                              .arrow_forward_ios,
                                                                          size: 10,))),
                                                              ),
                                                              HorizontalSpacing(
                                                                  width: Dimensions
                                                                      .w_10),
                                                            ],
                                                          ),
                                                          VerticalSpacing(
                                                              height: Dimensions
                                                                  .h_10),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .only(
                                                                left: Dimensions
                                                                    .w_10,
                                                                right: Dimensions
                                                                    .w_10),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                TradeBitTextWidget(
                                                                  title: 'EST APR',
                                                                  style: AppTextStyle
                                                                      .normalTextStyle(
                                                                      FontSize
                                                                          .sp_13,
                                                                      Theme
                                                                          .of(
                                                                          context)
                                                                          .shadowColor
                                                                  ),),
                                                                TradeBitTextWidget(
                                                                  title: '15%',
                                                                  style: AppTextStyle
                                                                      .normalTextStyle(
                                                                      FontSize
                                                                          .sp_13,
                                                                      AppColor
                                                                          .green
                                                                  ),),
                                                              ],
                                                            ),
                                                          ),
                                                          VerticalSpacing(
                                                              height: Dimensions
                                                                  .h_15),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .only(
                                                                left: Dimensions
                                                                    .w_10,
                                                                right: Dimensions
                                                                    .w_10),
                                                            child: TradeBitTextWidget(
                                                              title: '15% estimated APR for\nusers',
                                                              style: AppTextStyle
                                                                  .normalTextStyle(
                                                                  FontSize
                                                                      .sp_12,
                                                                  Theme
                                                                      .of(
                                                                      context)
                                                                      .shadowColor
                                                              ),),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    VerticalSpacing(
                                                        height: Dimensions.h_6),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPersistentHeader(
                          delegate: MySliverPersistentHeaderDelegate(
                            TabBar(
                                physics: const NeverScrollableScrollPhysics(),
                                overlayColor: MaterialStateProperty.all<Color>(
                                    AppColor.transparent),
                                onTap: (int index) async {},
                                indicatorColor: AppColor.appColor,
                                labelPadding: EdgeInsets.zero,
                                labelColor: AppColor.appColor,
                                unselectedLabelStyle: AppTextStyle
                                    .normalTextStyle(FontSize.sp_14, Theme
                                    .of(context)
                                    .highlightColor),
                                labelStyle: AppTextStyle.normalTextStyle(
                                    FontSize.sp_16,
                                    Theme
                                        .of(context)
                                        .highlightColor),
                                unselectedLabelColor:
                                Theme
                                    .of(context)
                                    .highlightColor,
                                indicatorSize: TabBarIndicatorSize.tab,
                                controller: _tabController,
                                tabs: [
                                  for (int i = 0; i < dataList.length; i++)
                                    Tab(
                                      child: Text(
                                        dataList[i].toString(),
                                        style: AppTextStyle
                                            .themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_14,
                                            color: Theme
                                                .of(context)
                                                .highlightColor
                                        ),
                                      ),
                                    ),
                                ]
                            ),
                          ),
                          pinned: true,
                          floating: false,
                        ),
                      ];
                    },
                    body: Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.only(
                          left: Dimensions.w_8, right: Dimensions.w_8),
                      color: Theme
                          .of(context)
                          .cardColor,
                      child: TabBarView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                            Column(
                              children: [
                                LocalStorage
                                    .getListCrypto()
                                    .isNotEmpty ? SpotStreamWidget(
                                    controller: controller) : Expanded(
                                  child: SizedBox(
                                      height: Dimensions.h_200,
                                      width: Dimensions.w_200,
                                      child: Lottie.asset(
                                          Images.searchAnimation)),
                                )
                              ],
                            ),
                            controller.gainers.isEmpty ?
                            Center(
                                child: SizedBox(
                                    height: Dimensions.h_200,
                                    width: Dimensions.w_200,
                                    child: Lottie.asset(Images.searchAnimation))
                            ) :
                            GainersStream(controller: controller,
                                list: controller.gainers),
                            controller.losers.isEmpty ?
                            Center(
                                child: SizedBox(
                                    height: Dimensions.h_200,
                                    width: Dimensions.w_200,
                                    child: Lottie.asset(Images.searchAnimation))
                            ) :
                            LosersStream(controller: controller,
                                list: controller.losers)
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  MySliverPersistentHeaderDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_8),
      padding: const EdgeInsets.only(left: 15,right: 15,top: 0),
      decoration:  BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
        )
      ),
      height: Dimensions.h_70,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant MySliverPersistentHeaderDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}