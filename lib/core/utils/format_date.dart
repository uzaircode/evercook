import 'package:intl/intl.dart';

String formatDatebdMMMYYY(DateTime dateTime) {
  return DateFormat("d MMM, yyy").format(dateTime);
}
