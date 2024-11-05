import 'dart:convert';

String basicProfileEmailCodeToJson(BasicProfileEmailCode data) => json.encode(data.toJson());

class BasicProfileEmailCode {
  final String email;
  final String type;

  BasicProfileEmailCode({
    required this.email,
    required this.type,
  });


  Map<String, dynamic> toJson() => {
    "email": email,
    "type": type,
  };
}
