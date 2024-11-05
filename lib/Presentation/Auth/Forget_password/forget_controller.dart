import 'dart:async';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Auth/login/login.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/auth_repository_imp.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/forgot_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/phone_forgot_request.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';

class ForgotController extends GetxController {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isPhone = false;
  bool loading = false;
  bool isEmail = true;
  Country? countryCode;
  AuthRepositoryImpl repositoryImpl = AuthRepositoryImpl();

  emailButton() {
    isEmail = !isEmail;
    isPhone = !isPhone;
    update([ControllerBuilders.forgotController]);
  }

  forgotByEmail(BuildContext context) async {
    if(emailTextController.text.isEmpty) {
      ToastUtils.showCustomToast(context, 'Please enter email', false);
    } else {
      loading = true;
      update([ControllerBuilders.forgotController]);

      var request = ForgotByEmailRequest(
          email: emailTextController.text
      );
      var data = await repositoryImpl.forgotByEmail(request);
      data.fold((l) {
        if (l is ServerFailure) {
          loading = false;
          update([ControllerBuilders.forgotController]);
          ToastUtils.showCustomToast(context, l.message ?? '', false);
        }
      }, (r) {
        String code = r.statusCode ?? '';
        String message = r.message ?? '';
        if (code == '1') {
          ToastUtils.showCustomToast(context, message, true);
          loading = false;
          update([ControllerBuilders.forgotController]);
          Timer(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const Login()));
          });
        } else {
          loading = false;
          update([ControllerBuilders.forgotController]);
          ToastUtils.showCustomToast(context, message, false);
        }

        update([ControllerBuilders.forgotController]);
      });
    }


  }

  forgotMobile(BuildContext context) async {

    var request = ForgotByMobile(
      mobile: phoneController.text
    );
    var data = await repositoryImpl.forgotByPhone(request);
    data.fold((l) {
      if (l is ServerFailure) {
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusText ?? '';
      String message = r.message ?? '';
      if (code == 'Success') {
        ToastUtils.showCustomToast(context, message, true);

        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const Login()));
        });
      } else {
        ToastUtils.showCustomToast(context, message, false);
      }

    });
    update([ControllerBuilders.forgotController]);


  }

  onShowCountryCode(BuildContext context) {
    showCountryPicker(
      useSafeArea: true,
      showSearch: false,
      context: context,
      showPhoneCode: true,
      onSelect: (country) {
        countryCode = country;
        update([ControllerBuilders.forgotController]);
        },
      countryListTheme: CountryListThemeData(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        // Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }
}
