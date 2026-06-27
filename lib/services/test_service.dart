import 'package:shared_preferences/shared_preferences.dart';

class TestStorage {
  static const String lastTestDate = "last_test_date";
  static const String percentage = "mental_percentage";
  static const String severity = "mental_severity";
  static const String phq = "phq_score";
  static const String gad = "gad_score";
  static const String combined = "combined_score";

  static Future<void> saveResult({
    required double percentageValue,
    required String severityValue,
    required int phqScore,
    required int gadScore,
    required int combinedScore,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(lastTestDate, DateTime.now().toIso8601String());

    await prefs.setDouble(percentage, percentageValue);

    await prefs.setString(severity, severityValue);

    await prefs.setInt(phq, phqScore);

    await prefs.setInt(gad, gadScore);

    await prefs.setInt(combined, combinedScore);
  }

  static Future<bool> shouldTakeTest() async {
    final prefs = await SharedPreferences.getInstance();

    final dateString = prefs.getString(lastTestDate);

    if (dateString == null) return true;

    final lastDate = DateTime.parse(dateString);

    final now = DateTime.now();

    return now.difference(lastDate).inDays >= 30;
  }

  static Future<double> getPercentage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(percentage) ?? 0;
  }

  static Future<String> getSeverity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(severity) ?? "";
  }
}
