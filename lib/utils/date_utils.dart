import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String formatDateTime() {
    return DateFormat('dd-MM-yyyy kk:mm').format(this);
  }
}