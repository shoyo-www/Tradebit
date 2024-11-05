import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/onboarding/onborading.dart';

class IntroScreen extends StatefulWidget {
  final List<OnboardingData> onbordingDataList;
  final String pageRoute;

  const IntroScreen(this.onbordingDataList, this.pageRoute, {super.key});

  void skipPage(BuildContext context) {
    Get.toNamed(pageRoute);
  }

  @override
  IntroScreenState createState() {
    return  IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  final PageController controller =  PageController();
  int currentPage = 0;
  bool lastPage = false;
  bool firstPage = true;

  void onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if(widget.onbordingDataList.isEmpty) {
        firstPage = false;
      }
      if (currentPage == 0 || currentPage == widget.onbordingDataList.length - 1) {
        lastPage = true;
        firstPage = true;
      } else {
        lastPage = false;
        firstPage = false;
      }
    });
  }

  Widget _buildPageIndicator(int page) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: page == currentPage ? 10.0 : 6.0,
      width: page == currentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: page == currentPage ? Colors.white : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      color:  Colors.white,
      child: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: onPageChanged,
            children: widget.onbordingDataList,
          ),
         firstPage ? const SizedBox(): Positioned(
            bottom: 20,
              left: 30,
              child: firstPage ? const SizedBox() : GestureDetector(
                onTap:() {
                  controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn
                  );
                },
                  child: firstPage ? const SizedBox.shrink() : Image.asset(Images.backward,scale: 2.5))),
          Positioned(
              bottom: 70,
              left: 160,
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    _buildPageIndicator(0),
                    _buildPageIndicator(1),
                    _buildPageIndicator(2),
                  ],
                ),
              )),
          Positioned(
              bottom: 10,
              right: 30,
              child: lastPage ? GestureDetector(
                  onTap: () {
                    lastPage
                        ? widget.skipPage(context)
                        : controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                    LocalStorage.writeBool(GetXStorageConstants.onBoarding, true);
                  },
                  child: Image.asset(Images.forward,scale: 10.5)) : GestureDetector(
                onTap: () {
                  lastPage
                      ? widget.skipPage(context)
                      : controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                    LocalStorage.writeBool(GetXStorageConstants.onBoarding, true);
                },
                  child: Image.asset(Images.forward,scale: 10.5))),
        ],
      ),
    );
  }
}