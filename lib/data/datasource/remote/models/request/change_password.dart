import 'dart:convert';

String changePasswordRequestToJson(ChangePasswordRequest data) => json.encode(data.toJson());

class ChangePasswordRequest {
  final String? oldPassword;
  final String? newPassword;
  final String? confirmPassword;

  ChangePasswordRequest({
    this.oldPassword,
    this.newPassword,
    this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    "old_password": oldPassword,
    "new_password": newPassword,
    "confirm_password": confirmPassword,
  };
}
