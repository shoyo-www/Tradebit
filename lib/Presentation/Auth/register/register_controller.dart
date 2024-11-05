import 'dart:async';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Auth/otp/otp_screen.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/auth_repository_imp.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/email_register.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import '../../../data/datasource/remote/models/request/register_phone_request.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  bool agreeButtonTapped = false;
  bool closeEye = true;
  bool invitedClicked = false;
  bool isPhone = false;
  bool isEmail = true;
  bool isLoading = false;
  int? data;
  Country? countryCode;

  agreeButton() {
    agreeButtonTapped = !agreeButtonTapped;
    update([ControllerBuilders.registerController]);
  }

  invitedButtonClicked() {
    invitedClicked = !invitedClicked;
    update([ControllerBuilders.registerController]);
  }

  changeEye() {
    closeEye = !closeEye;
    update([ControllerBuilders.registerController]);
  }

  emailButton (BuildContext context) {
    isEmail = true;
    isPhone = false;
    passwordController.clear();
    passwordController.clear();
    update([ControllerBuilders.registerController]);
  }
  phoneButton() {
    isEmail = false;
    isPhone = true;
    emailController.clear();
    passwordController.clear();
    update([ControllerBuilders.registerController]);
  }

  AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl();


   onShowCountryCode(BuildContext context) {
     showCountryPicker(
       useSafeArea: true,
       showSearch: true,
       context: context,
       showPhoneCode: true,
       onSelect: (country) {
         countryCode = country;
         update([ControllerBuilders.registerController]);
       },
       countryListTheme: CountryListThemeData(
         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
         margin: EdgeInsets.only(top: Dimensions.h_120),
         padding: EdgeInsets.only(top: Dimensions.h_10),
         borderRadius: const BorderRadius.only(
           topLeft: Radius.circular(40.0),
           topRight: Radius.circular(40.0),
         ),
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

  registerByMobile(BuildContext context) async {
    isLoading = true;
    update([ControllerBuilders.registerController]);
    var request = RegisterMobileRequest(
        countryCode: countryCode?.countryCode ?? 'IN',
        mobile: phoneController.text,
        countryCallingCode: countryCode?.phoneCode ?? '91',
        password: passwordController.text,
        referral: '',
        terms: agreeButtonTapped);

    var data = await authRepositoryImpl.registerMobile(request);

    data.fold(
        (l) => {
              if (l is ServerFailure)
              {

                  ToastUtils.showCustomToast(context, l.message ?? '', false),
                isLoading = false,
                  update([ControllerBuilders.registerController])


    }

            }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == ApiStatus.success) {
        ToastUtils.showCustomToast(context, message, true);
         isLoading = false;
         update([ControllerBuilders.registerController]);
        Timer(const Duration(seconds: 2), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  Otp(token: r.data?.token ?? '',mobile: r.data?.mobile ?? '',)));
        });
      } else {
        ToastUtils.showCustomToast(context, message, false);
         isLoading = false;
         update([ControllerBuilders.registerController]);
      }
    });
    update([ControllerBuilders.registerController]);
  }

  registerByEmail(BuildContext context) async {
    isLoading = true;
    update([ControllerBuilders.registerController]);
    var request = RegisterEmailRequest(
      email: emailController.text,
      password: passwordController.text,
      referral: '',
      terms: agreeButtonTapped,
    );
    var data = await authRepositoryImpl.registerEmail(request);
    data.fold((l) {
      if (l is ServerFailure) {
        isLoading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == ApiStatus.success) {
        isLoading = false;
        ToastUtils.showCustomToast(context, message, true);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  Otp(
                type: 'email',
                email: r.data?.email ?? '',
                screenType: 'register',
                token: r.data?.token ?? '',
              )));
      } else {
        ToastUtils.showCustomToast(context, message, false);
        update([ControllerBuilders.registerController]);
      }
    });
    isLoading = false;
    update([ControllerBuilders.registerController]);
  }
}
