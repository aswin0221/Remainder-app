import 'package:intl/intl.dart';

class DateFormater {

  static String convertDate(DateTime dateTime) {
    String formattedDate = DateFormat("d`MMM h:mm a").format(dateTime);
    return formattedDate;
  }
  }