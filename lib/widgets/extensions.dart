import 'package:intl/intl.dart';

extension DateFormating on DateTime {
  String toDateString(String toFormat,) {
    return DateFormat(toFormat).format(this);
  }
}