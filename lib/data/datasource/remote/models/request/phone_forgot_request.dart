
import 'dart:convert';


String forgotByMobileToJson(ForgotByMobile data) => json.encode(data.toJson());

class ForgotByMobile {
  final String mobile;

  ForgotByMobile({
    required this.mobile,
  });

  Map<String, dynamic> toJson() => {
    "mobile": mobile,
  };
}
