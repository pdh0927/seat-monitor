class DataUtils {
  static DateTime dateTimeFromJson(String dateTime) {
    return DateTime.parse(dateTime).toLocal();
  }

  static String dateTimeToJson(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }
}
