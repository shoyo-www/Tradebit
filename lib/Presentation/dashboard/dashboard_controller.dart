import 'package:get/get.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  void navigateToPage(int index) {
    // Implement your navigation logic here
    switch (index) {
      case 0:
      // Navigate to HomePage
        break;
      case 1:
      // Navigate to MarketPage
        break;
      case 2:
      // Navigate to ExchangePage
        break;
      case 3:
      // Navigate to WalletPage or Login based on user login status
        break;
      case 4:
      // Navigate to StakingPage
        break;
      default:
      // Navigate to HomePage as a fallback
        break;
    }
  }
}