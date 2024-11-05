import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Auth/login/login.dart';
import 'package:tradebit_app/Presentation/setting/setting.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/auth_repository_imp.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/change_password.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';

class ChangePasswordController extends GetxController {
  bool isLoading = false;
  bool closeEye = false;
  bool closeConfirm = false;
  TextEditingController oldPasswordController=TextEditingController();
  TextEditingController newPasswordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
  GlobalKey<FormState> changePasswordKey = GlobalKey<FormState>();
  final AuthRepositoryImpl repositoryImpl = AuthRepositoryImpl();


  changeEyeConfirm() {
    closeConfirm = !closeConfirm;
    update([ControllerBuilders.changePasswordController]);
  }

  changeEye() {
    closeEye = !closeEye;
    update([ControllerBuilders.changePasswordController]);
  }

  onResetButton(BuildContext context) async {
    if(changePasswordKey.currentState!.validate()) {
     if(newPasswordController.text != confirmPasswordController.text ) {
       ToastUtils.showCustomToast(context, "Confirm password doesn't match", false);
     }else{
       isLoading = true;
       update([ControllerBuilders.changePasswordController]);
       var request = ChangePasswordRequest(
         confirmPassword: confirmPasswordController.text,
         newPassword: newPasswordController.text,
         oldPassword: oldPasswordController.text
       );
       var data = await repositoryImpl.changePassword(request);
       data.fold((l) {
         if (l is ServerFailure) {
           ToastUtils.showCustomToast(context, l.message ?? '', false);
           isLoading = false;
         }
       }, (r) {
         String code = r.statusCode ?? '';
         String message = r.message ?? '';
         if (code == '1') {
           ToastUtils.showCustomToast(context, message, true);
           isLoading = false;
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> Login()));
         }
         else {
           isLoading = false;
           update([ControllerBuilders.changePasswordController]);
           ToastUtils.showCustomToast(context, message, false);
         }
       }
       );
       update([ControllerBuilders.changePasswordController]);
     }
     }
    }
  }