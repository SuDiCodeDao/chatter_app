import 'package:intl/intl.dart';

String formatLastMessageTime(String lastMessageTime) {
  if (lastMessageTime == null || lastMessageTime.isEmpty) {
    return '';
  }
  final parts = lastMessageTime.split(" ");
  if (parts.length != 2) {
    return '';
  }
  final datePart = parts[0];
  final timePart = parts[1];
  final dateParts = datePart.split("-");
  final timeParts = timePart.split(":");

  if (dateParts.length != 3 || timeParts.length != 3) {
    return '';
  }
  final year = dateParts[0];
  final month = dateParts[1];
  final day = dateParts[2];
  final hour = timeParts[0];
  final minute = timeParts[1];
  final second = timeParts[2].split(".")[0];

  final now = DateTime.now();
  if (year == now.year.toString() &&
      month == now.month.toString() &&
      day == now.day.toString()) {
    return '$hour:$minute';
  } else if (year != now.year.toString()) {
    return '$day/$month/$year $hour:$minute';
  } else {
    return '$day/$month $hour:$minute';
  }
}
