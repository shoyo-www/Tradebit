import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/kyc_repository_impl.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/generate_addhar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:image/image.dart' as img;
import 'package:tradebit_app/widgets/tradebit_text.dart';

class KycController extends GetxController {
  int index = 0;
  bool personalDetails = true;
  bool id = false;
  bool buttonLoading = false;
  bool done = false;
  bool adhaar = false;
  bool passport = false;
  bool otp = false;
  bool pan = false;
  bool driving = false;
  String? refid;
  bool national = false;
  String? accessToken;
  String gender = 'Male';
  File? frontImage;
  File? selfie;
  String? front;
  Country? countryName;
  bool isTimerEnabled = false;
  int endTime = 0;
  String? back;
  File? backImage;
  String? cardType;
  final KycRepositoryImpl _repositoryImpl = KycRepositoryImpl();
  TextEditingController documentController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final _picker = ImagePicker();
  DateTime? selectedDate;
  String date = 'Select Date';

  Future<void> openFrontImagePicker() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.front,imageQuality: 10);
    if (pickedImage != null ) {
      File image = File(pickedImage.path);
      frontImage = compressAndResizeImage(image);
      update([ControllerBuilders.kycController]);
    }
  }

  Future<void> openSelfieFrontImagePicker() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.front,imageQuality: 10);
    if (pickedImage != null) {
      selfie = File(pickedImage.path);
      update([ControllerBuilders.kycController]);
    }
  }

  Future<void> openBackImagePicker() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.rear,imageQuality: 10);
    if (pickedImage != null) {
      File image = File(pickedImage.path);
      backImage = compressAndResizeImage(image);
      update([ControllerBuilders.kycController]);
    }
  }

  onCalender() {
    update([ControllerBuilders.kycController]);
  }


  File compressAndResizeImage(File file) {
    img.Image? image = img.decodeImage(file.readAsBytesSync());
    int width;
    int height;

    if (image!.width > image.height) {
      width = 800;
      height = (image.height / image.width * 800).round();
    } else {
      height = 800;
      width = (image.width / image.height * 800).round();
    }

    img.Image resizedImage = img.copyResize(image, width: width, height: height);
    List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 85);  // Adjust quality as needed
    File compressedFile = File(file.path.replaceFirst('.jpg', '_compressed.jpg'));
    compressedFile.writeAsBytesSync(compressedBytes);
    return compressedFile;
  }

  onAdhaar() {
    adhaar = true;
     pan = false;
     driving = false;
     passport = false;
    national = false;
    cardType = 'aadhaarcard';
    frontImage =null;
    backImage =null;
    selfie = null;
   update([ControllerBuilders.kycController]);
  }
  onNational() {
    adhaar = false;
    pan = false;
    driving = false;
    passport = false;
    national = true;
    cardType = 'nationalcard';
    frontImage =null;
    backImage =null;
    selfie = null;
    update([ControllerBuilders.kycController]);
  }

  onPan() {
    adhaar = false;
    pan = true;
    driving = false;
    passport = false;
    national = false;
    cardType = 'pancard';
    frontImage =null;
    backImage =null;
    selfie = null;
    update([ControllerBuilders.kycController]);
  }

  onDriving() {
    adhaar = false;
    pan = false;
    driving = true;
    passport = false;
    national = false;
    cardType = 'drivinglicense';
    frontImage =null;
    backImage =null;
    selfie = null;
    update([ControllerBuilders.kycController]);
  }
  onPassport() {
    adhaar = false;
    pan = false;
    driving = false;
    passport = true;
    national = false;
    cardType = 'passport';
    frontImage =null;
    backImage =null;
    selfie = null;
    update([ControllerBuilders.kycController]);
  }

  onNextTapped(BuildContext context) {
    index = 1;
    id = true;
    update([ControllerBuilders.kycController]);

  }

  onSubmitTapped(BuildContext context) {
    index = 2;
    id = false;
    done = true;
    update([ControllerBuilders.kycController]);
  }

  void startTimer() {
    endTime = DateTime.now().millisecondsSinceEpoch + 120000;
    isTimerEnabled = true;
    update([ControllerBuilders.kycController]);
  }

  void showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: Dimensions.h_300,
            color: Theme.of(context).cardColor,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime newDateTime) {
                  selectedDate = newDateTime;
                  date = DateFormat('yyyy-MM-dd').format(selectedDate?? DateTime(100));
                  update([ControllerBuilders.datePicker]);
                  },
              initialDateTime: selectedDate ?? DateTime.now(),
              minimumYear: DateTime.now().year - 100,
              maximumYear: DateTime.now().year,
            ),
          ),
        );
      },
    );
  }

  onResend(BuildContext context) async{
    buttonLoading = true;
    update([ControllerBuilders.kycController]);
    final request = GenerateKycOtpRequest(
        countryCode: 'in',
        documentNumber: documentController.text,
        documentType: 'aadhaarcard'

    );
    var data = await _repositoryImpl.generateKycOtp(request);
    data.fold((l) {
      if (l is ServerFailure) {
        buttonLoading = false;
        update([ControllerBuilders.kycController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        refid = r.data?.refId ?? '';
        accessToken = r.data?.accessToken ?? '';
        startTimer();
        ToastUtils.showCustomToast(context, message, true);
        buttonLoading = false;
        update([ControllerBuilders.kycController]);
      }
      else {
        ToastUtils.showCustomToast(context, message, false);
        buttonLoading = false;
        update([ControllerBuilders.kycController]);
      }
    });
    update([ControllerBuilders.kycController]);
  }

  onHomeTapped(BuildContext context) {
    personalDetails = true;
    id = false;
    done = false;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DashBoard(index: 0)));
    index = 0;
    update([ControllerBuilders.kycController]);
  }

  getBack() {
    personalDetails = true;
    id = false;
    index = 0;
    frontImage =null;
    backImage =null;
    selfie = null;
    adhaar = false;
    pan = false;
    driving = false;
    passport = false;
    national = false;
    documentController.clear();
    update([ControllerBuilders.kycController]);
  }

  onGenerateOtp(BuildContext context) async {
    if(formKey2.currentState!.validate()) {
      buttonLoading = true;
      update([ControllerBuilders.kycController]);
      final request = GenerateKycOtpRequest(
          countryCode: '+91',
          documentNumber: documentController.text,
          documentType: 'aadhaarcard'

      );
      var data = await _repositoryImpl.generateKycOtp(request);
      data.fold((l) {
        if (l is ServerFailure) {
          buttonLoading = false;
          update([ControllerBuilders.kycController]);
          ToastUtils.showCustomToast(context, l.message ?? '', false);
        }
      }, (r) {
        String code = r.statusCode ?? '';
        String message = r.message ?? '';
        if (code == '1') {
          refid = r.data?.refId ?? '';
          accessToken = r.data?.accessToken ?? '';
          otp = true;
          isTimerEnabled = true;
          startTimer();
          ToastUtils.showCustomToast(context, message, true);
          buttonLoading = false;
          update([ControllerBuilders.kycController]);
        }
        else {
          ToastUtils.showCustomToast(context, message, false);
          buttonLoading = false;
          update([ControllerBuilders.kycController]);
        }
      });
      update([ControllerBuilders.kycController]);
    }

  }

  showSheet (BuildContext context) {
    return showModalBottomSheet
      (backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        elevation: 0,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.25,
              maxChildSize: 0.25,
              minChildSize: 0.25,
              expand: true,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20),
                  decoration:  BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalSpacing(height: Dimensions.h_10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TradeBitTextWidget(title: 'Select Gender', style: AppTextStyle.themeBoldNormalTextStyle(
                            fontSize: FontSize.sp_20,
                            color: Theme.of(context).shadowColor
                          )),
                          GestureDetector(
                            onTap: ()=> Navigator.pop(context),
                              child: Icon(Icons.clear,color: Theme.of(context).shadowColor,size: 17,)),
                        ],
                      ),
                      VerticalSpacing(height: Dimensions.h_20),
                      GestureDetector(
                        onTap: () {
                          gender = 'Male';
                          Navigator.pop(context);
                          update([ControllerBuilders.kycController]);
                        },
                        child: TradeBitTextWidget(title: 'Male', style: AppTextStyle.themeBoldNormalTextStyle(
                          fontSize: FontSize.sp_18,
                          color: Theme.of(context).highlightColor
                        )),
                      ),
                      VerticalSpacing(height: Dimensions.h_3),
                      Divider(color: Theme.of(context).shadowColor.withOpacity(0.2),),
                      VerticalSpacing(height: Dimensions.h_3),
                      GestureDetector(
                        onTap: () {
                          gender = 'Female';
                          Navigator.pop(context);
                          update([ControllerBuilders.kycController]);
                        },
                        child: TradeBitTextWidget(title: 'Female', style: AppTextStyle.themeBoldNormalTextStyle(
                            fontSize: FontSize.sp_18,
                            color: Theme.of(context).highlightColor
                        )),
                      ),
                      VerticalSpacing(height: Dimensions.h_3),
                      Divider(color: Theme.of(context).shadowColor.withOpacity(0.2),),
                      VerticalSpacing(height: Dimensions.h_3),
                    ],
                  ),
                );
              }
          );
        }
    );
  }

  onTap(BuildContext context) {
    showCountryPicker(
      useSafeArea: true,
      context: context,
      showPhoneCode: true,
      showSearch: true,
      onSelect: (Country country) {
        countryName = country;
        if(countryName?.name == 'India') {
          adhaar = true;
          national = false;
          pan = false;
          driving = false;
          passport = false;
          update([ControllerBuilders.kycController]);
        } else {
          adhaar = false;
          national = true;
          pan = false;
          driving = false;
          passport =false;
          update([ControllerBuilders.kycController]);
        }
        update([ControllerBuilders.kycController]);
      },
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: MediaQuery.of(context).size.height / 1.5,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        inputDecoration: InputDecoration(
          iconColor: Theme.of(context).highlightColor,
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon:  Icon(Icons.search,color: Theme.of(context).highlightColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
        searchTextStyle: AppTextStyle.normalTextStyle(FontSize.sp_16, Theme.of(context).highlightColor)
      ),
    );
  }
}