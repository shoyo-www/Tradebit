import 'dart:convert';

String updateProfileRequestToJson(UpdateProfileRequest data) => json.encode(data.toJson());

class UpdateProfileRequest {
  final String location;
  final int step;
  final String firstName;
  final String lastName;
  final String email;
  final String emailVcode;
  final String mobile;
  final String mobileVcode;
  final String countryCode;
  final String countryCallingCode;

  UpdateProfileRequest({
    required this.location,
    required this.step,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.emailVcode,
    required this.mobile,
    required this.mobileVcode,
    required this.countryCode,
    required this.countryCallingCode,
  });


  Map<String, dynamic> toJson() => {
    "location": location,
    "step": step,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "email_vcode": emailVcode,
    "mobile": mobile,
    "mobile_vcode": mobileVcode,
    "country_code": countryCode,
    "country_calling_code": countryCallingCode,
  };
}
