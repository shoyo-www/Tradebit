import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/fontsize.dart';

class ToastUtils {
  static Timer? toastTimer;
  static OverlayEntry? _overlayEntry;
  static void showCustomToast(
      BuildContext context, String message, bool isSuccess) {
    if (toastTimer == null || !(toastTimer?.isActive ?? false)) {
      _overlayEntry = createOverlayEntry(context, message, isSuccess);
      Overlay.of(context).insert(_overlayEntry!);
      toastTimer = Timer(const Duration(seconds: 2), () {
        if (_overlayEntry != null) {
          _overlayEntry?.remove();
        }
      });
    }
  }

  static OverlayEntry createOverlayEntry(
      BuildContext context, String message, bool isSuccess) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: Dimensions.h_50,
        right: Dimensions.w_15,
        left: Dimensions.w_15,
        child: Material(
          elevation: 1.0,
          color: isSuccess ? AppColor.green : AppColor.red.withOpacity(0.7),
          borderRadius: BorderRadius.circular(Dimensions.h_10),
          child: Container(
            width: MediaQuery.of(context).size.width - Dimensions.w_20,
            padding: EdgeInsets.only(
                left: Dimensions.w_10,
                right: Dimensions.w_10,
                top: Dimensions.h_12,
                bottom: Dimensions.h_12),
            decoration: BoxDecoration(
                color: isSuccess ? AppColor.green : AppColor.red.withOpacity(0.7),
                borderRadius: BorderRadius.circular(Dimensions.h_10)),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Icon(
                    isSuccess ? CupertinoIcons.checkmark_circle_fill : Icons.cancel,
                    color: AppColor.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: SizedBox(
                      width: Dimensions.w_200,
                      child: Text(
                        message,
                        maxLines: 3,
                        style: AppTextStyle.themeBoldNormalTextStyle(
                            fontSize: FontSize.sp_13,
                            color: AppColor.white)
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
