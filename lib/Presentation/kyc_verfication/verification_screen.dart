import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:tradebit_app/Presentation/kyc_verfication/kyc_controller.dart';
import 'package:tradebit_app/Presentation/kyc_verfication/kyc_verified.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/common_response.dart';
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';
import 'package:tradebit_app/widgets/tradebit_textfield.dart';

class VerificationKyc extends StatefulWidget {
  final KycController controller;
  const VerificationKyc({super.key,required this.controller});

  @override
  State<VerificationKyc> createState() => _VerificationKycState();
}

class _VerificationKycState extends State<VerificationKyc> {
  bool loading = false;
  CommonResponse? data;
  Future<dynamic> upload() async {
    loading = true;
    setState(() {});
    if (widget.controller.frontImage == null) return;
    String? selfie = widget.controller.selfie?.path.split('/').last;
    String? fileName = widget.controller.frontImage?.path.split('/').last;
    String? back = widget.controller.backImage?.path.split('/').last;

    FormData formData = FormData();

    formData.fields.addAll([
      MapEntry("first_name", widget.controller.nameController.text),
      MapEntry("last_name", widget.controller.lastController.text),
      MapEntry("date_birth", widget.controller.date),
      MapEntry("address", widget.controller.addressController.text),
      MapEntry("identity_type", widget.controller.cardType ?? ''),
      MapEntry("identity_number", widget.controller.documentController.text),
      MapEntry("otp_code", widget.controller.otpController.text),
      MapEntry("ref_id", widget.controller.refid ?? ''),
      MapEntry("access_token", widget.controller.accessToken ?? ''),
      MapEntry("country", widget.controller.countryName?.countryCode ?? ''),
    ]);

    formData.files.addAll([
      MapEntry(
        "selfie",
        await MultipartFile.fromFile(widget.controller.selfie?.path ?? '', filename: selfie),
      ),
      MapEntry(
        "identity_front_path",
        await MultipartFile.fromFile(widget.controller.frontImage?.path ?? '', filename: fileName),
      ),
      MapEntry(
        "identity_back_path",
        await MultipartFile.fromFile(widget.controller.backImage?.path ?? '', filename: back),
      ),
    ]);

    try {
      Response response = await Dio().post(Apis.verifyKyc, data: formData, options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${LocalStorage.getAuthToken()}",
          },
          followRedirects: true,
          responseType: ResponseType.plain,
          validateStatus: (status) => status! < 500
      ),);
      if(response.statusCode == 200) {
        var res = response.data;
         data = commonResponseFromJson(res.toString());
         if(data?.statusCode == '1') {
           log(data.toString());
           loading = false;
           setState(() {});
           ToastUtils.showCustomToast(context, data?.message ?? '', true);
           Navigator.push(context, MaterialPageRoute(builder: (context)=> KycVerified(message: data?.message ?? '')));
         } else {
           loading = false;
           setState(() {});
           ToastUtils.showCustomToast(context, data?.message ?? '', false);
         }
         print(data?.message);
         setState(() {});
      }
    } catch (error) {
      loading = false;
      ToastUtils.showCustomToast(context, error.toString() ?? '', false);
      setState(() {});
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return TradeBitContainer(
      padding: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20,top: Dimensions.h_30),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)
          )
      ),
      child: Form(
        key: widget.controller.formKey2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TradeBitTextWidget(title: 'Select Country', style: AppTextStyle.themeBoldNormalTextStyle(
                fontSize: FontSize.sp_17,
                color: Theme.of(context).shadowColor
            )),
            VerticalSpacing(height: Dimensions.h_8),
            GestureDetector(
              onTap: ()=> widget.controller.onTap(context),
              child: TradeBitContainer(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12)
                ),
                padding: EdgeInsets.only(top: Dimensions.h_13,bottom: Dimensions.h_13,left: Dimensions.w_10),
                child: Row(
                  children: [
                    TradeBitTextWidget(title: widget.controller.countryName?.flagEmoji ?? '', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor)),
                    HorizontalSpacing(width: Dimensions.w_10),
                    TradeBitTextWidget(title: widget.controller.countryName?.name ?? 'select', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor)),
                  ],
                ),
              ),
            ),
            widget.controller.countryName?.name == 'India' ? VerticalSpacing(height: Dimensions.h_25) : VerticalSpacing(height: Dimensions.h_15),
            Column(
              children: [
                Visibility(
                  visible: widget.controller.countryName?.name == 'India',
                  child: GestureDetector(
                    onTap: () {
                      widget.controller.onAdhaar();
                    },
                    child: TradeBitContainer(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.w_8,right: Dimensions.w_8),
                      decoration: BoxDecoration(
                        color: widget.controller.adhaar ? AppColor.appColor : Theme.of(context).shadowColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TradeBitTextWidget(title: 'Aadhaar Card',style: AppTextStyle.themeBoldNormalTextStyle(
                        fontSize: FontSize.sp_15,
                        color: widget.controller.adhaar ? AppColor.white : Theme.of(context).shadowColor,
                      ),),
                    ),
                  ),
                ),
                widget.controller.countryName?.name == 'India' ? VerticalSpacing(height: Dimensions.h_10) : const VerticalSpacing(height: 0),
                Visibility(
                  visible: widget.controller.countryName?.name == 'India',
                  child: GestureDetector(
                    onTap: () {
                      widget.controller.onPan();
                    },
                    child: TradeBitContainer(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.w_8,right: Dimensions.w_15),
                      decoration: BoxDecoration(
                        color: widget.controller.pan ? AppColor.appColor : Theme.of(context).shadowColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TradeBitTextWidget(title: 'Pan Card',style: AppTextStyle.themeBoldNormalTextStyle(
                            fontSize: FontSize.sp_15,
                            color: widget.controller.pan ? AppColor.white : Theme.of(context).shadowColor,
                          ),),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.controller.countryName?.name != 'India',
                  child: GestureDetector(
                    onTap: () {
                      widget.controller.onNational();
                    },
                    child: TradeBitContainer(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.w_8,right: Dimensions.w_15),
                      decoration: BoxDecoration(
                        color: widget.controller.national ? AppColor.appColor : Theme.of(context).shadowColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TradeBitTextWidget(title: 'National ID',style: AppTextStyle.themeBoldNormalTextStyle(
                            fontSize: FontSize.sp_15,
                            color: widget.controller.national ? AppColor.white : Theme.of(context).shadowColor,
                          ),),
                        ],
                      ),
                    ),
                  ),
                ),
                VerticalSpacing(height: Dimensions.h_10),
                GestureDetector(
                  onTap: () {
                    widget.controller.onDriving();
                  },
                  child: TradeBitContainer(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.w_8,right: Dimensions.w_15),
                    decoration: BoxDecoration(
                      color: widget.controller.driving ?  AppColor.appColor : Theme.of(context).shadowColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TradeBitTextWidget(title: 'Driving License',style: AppTextStyle.themeBoldNormalTextStyle(
                          fontSize: FontSize.sp_15,
                          color: widget.controller.driving ? AppColor.white : Theme.of(context).shadowColor,
                        ),),
                      ],
                    ),
                  ),
                ),
                VerticalSpacing(height: Dimensions.h_10),
                GestureDetector(
                  onTap: () {
                    widget.controller.onPassport();
                  },
                  child: TradeBitContainer(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.w_8,right: Dimensions.w_15),
                    decoration: BoxDecoration(
                      color: widget.controller.passport ?  AppColor.appColor : Theme.of(context).shadowColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TradeBitTextWidget(title: 'Passport',style: AppTextStyle.themeBoldNormalTextStyle(
                          fontSize: FontSize.sp_15,
                          color: widget.controller.passport ? AppColor.white : Theme.of(context).shadowColor,
                        ),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            VerticalSpacing(height: Dimensions.h_25),
            TradeBitTextWidget(title: 'Upload ID Proof', style: AppTextStyle.themeBoldNormalTextStyle(
              fontSize: FontSize.sp_16,
              color: Theme.of(context).highlightColor,
            )),
            VerticalSpacing(height: Dimensions.h_5),
            TradeBitTextWidget(title: 'Document should be on a plain dark surface and make\nsure that the corner are visible ', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
            VerticalSpacing(height: Dimensions.h_20),
            GestureDetector(
              onTap: () {
                widget.controller.openSelfieFrontImagePicker();
              },
              child: TradeBitContainer(
                height: Dimensions.h_150,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).shadowColor,
                        width: 0.5
                    ),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: widget.controller.selfie != null ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(widget.controller.selfie ?? File(''),fit: BoxFit.fill)) : Center(
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: Dimensions.h_40,
                          width: Dimensions.h_40,
                          child: Image.asset(Images.uploadFront)),
                      VerticalSpacing(height: Dimensions.h_5),
                      TradeBitTextWidget(title: 'Upload Selfie', style: AppTextStyle.themeBoldNormalTextStyle(
                          fontSize: FontSize.sp_16,
                          color: Theme.of(context).highlightColor
                      ))
                    ],
                  ),
                ),
              ),
            ),
            VerticalSpacing(height: Dimensions.h_5),
            TradeBitTextWidget(title: 'File accepted: JPEG/JPG/PNG (Max size : 150kb) ', style: AppTextStyle.normalTextStyle(
              FontSize.sp_13,
                Theme.of(context).shadowColor
            )),
            VerticalSpacing(height: Dimensions.h_10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.controller.openFrontImagePicker();
                    },
                    child: TradeBitContainer(
                      height: Dimensions.h_150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).shadowColor,
                          width: 0.5
                        ),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: widget.controller.frontImage != null ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                          child: Image.file(widget.controller.frontImage ?? File(''),fit: BoxFit.cover,)) : Center(
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: Dimensions.h_40,
                                width: Dimensions.h_40,
                                child: Image.asset(Images.uploadFront)),
                            VerticalSpacing(height: Dimensions.h_5),
                            TradeBitTextWidget(title: 'Upload Front', style: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_16,
                                color: Theme.of(context).highlightColor
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                HorizontalSpacing(width: Dimensions.w_15),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.controller.openBackImagePicker();
                    },
                    child: TradeBitContainer(
                      height: Dimensions.h_150,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).shadowColor,
                          width: 0.5
                        ),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child:  widget.controller.backImage != null ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                          child: Image.file(widget.controller.backImage ?? File(""),fit: BoxFit.cover,)) : Center(
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: Dimensions.h_40,
                                width: Dimensions.h_40,
                                child: Image.asset(Images.uploadBack)),
                            VerticalSpacing(height: Dimensions.h_5),
                            TradeBitTextWidget(title: 'Upload Back', style: AppTextStyle.themeBoldNormalTextStyle(
                              fontSize: FontSize.sp_16,
                              color: Theme.of(context).highlightColor
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            VerticalSpacing(height: Dimensions.h_5),
            TradeBitTextWidget(title: 'File accepted: JPEG/JPG/PNG (Max size : 512kb) ', style: AppTextStyle.normalTextStyle(
                FontSize.sp_13,
                Theme.of(context).shadowColor
            )),
            VerticalSpacing(height: Dimensions.h_30),
            Stack(
              children: [
                TradeBitTextFieldLabel(
                    hintText: 'Enter Document Number',
                    title: 'Document Number',
                    controller: widget.controller.documentController,
                    borderEnable: false,
                    inputFormatters: [ FilteringTextInputFormatter.digitsOnly],
                    color: Theme.of(context).scaffoldBackgroundColor,
                    keyboardType: TextInputType.number,
                    validator: Validator.documentNumber),
                // Visibility(
                //   visible: widget.controller.countryName?.name == 'India' && widget.controller.adhaar,
                //   child: Positioned(
                //     right: 0,
                //       child: GestureDetector(
                //         onTap: () {
                //           widget.controller.buttonLoading ? null : widget.controller.onGenerateOtp(context);
                //         },
                //           child:  widget.controller.isTimerEnabled ? Align(
                //             alignment: Alignment.center,
                //             child: CountdownTimer(
                //               endWidget: GestureDetector(
                //                 onTap: () {
                //                   widget.controller.buttonLoading? null : widget.controller.onResend(context);
                //                 },
                //                 child: Text(
                //                    "Get Code",
                //                   style: AppTextStyle.themeBoldNormalTextStyle(
                //                       fontSize: FontSize.sp_13,
                //                       color: AppColor.appColor
                //                   ),
                //                   textAlign: TextAlign.center,
                //                 ),
                //               ),
                //               endTime: widget.controller.endTime,
                //               onEnd: () {
                //                 widget.controller.isTimerEnabled = false;
                //               },
                //               textStyle:  AppTextStyle.themeBoldNormalTextStyle(
                //                   fontSize: FontSize.sp_13,
                //                   color: AppColor.appColor
                //               ),
                //             ),
                //           )
                //               : Align(
                //             alignment: Alignment.center,
                //             child: GestureDetector(
                //               onTap: () {
                //                 widget.controller.buttonLoading? null : widget.controller.onResend(context);
                //                 widget.controller.isTimerEnabled = true;
                //               },
                //               child:  Text(
                //                 "Get Code",
                //                 style: AppTextStyle.themeBoldNormalTextStyle(
                //                     fontSize: FontSize.sp_13,
                //                     color: AppColor.appColor
                //                 ),
                //                 textAlign: TextAlign.center,
                //               ),
                //             ),
                //           ),)),
                // )
              ],
            ),
            // Visibility(
            //   visible: widget.controller.otp && widget.controller.adhaar,
            //     child: TradeBitTextFieldLabel(hintText: 'Enter OTP', title: 'Enter otp ', controller: widget.controller.otpController,borderEnable: false,color: Theme.of(context).scaffoldBackgroundColor,validator: Validator.otpValidate)),
            // VerticalSpacing(height: Dimensions.h_10),
            TradeBitTextButton(loading: loading,labelName: 'Submit', onTap: () {
                if(widget.controller.frontImage !=null && widget.controller.backImage !=null && widget.controller.selfie !=null && (widget.controller.countryName?.name.isNotEmpty ?? false)) {
                  setState(() {
                    if(widget.controller.formKey2.currentState!.validate()) {
                      upload();
                    }

                  });
                }else {
                  ToastUtils.showCustomToast(context, (widget.controller.countryName?.name.isEmpty ?? false) ? 'Select country':'Please Select Image', false);
                }

            },margin: EdgeInsets.zero,),
            VerticalSpacing(height: Dimensions.h_10),
            GestureDetector(
              onTap: () {
                widget.controller.getBack();
              },
              child: Center(
                child: TradeBitTextWidget(title: 'Back to Step 1', style: AppTextStyle.themeBoldNormalTextStyle(
                    fontSize: FontSize.sp_16,
                    color: AppColor.appColor
                )),
              ),
            ),
            VerticalSpacing(height: Dimensions.h_20)
          ],
        ),
      ),
    );
  }
}
