import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constants.dart';
import '../constants/mental_test_data.dart';
import '../services/test_service.dart';

class CalmZoneTestScreen extends StatefulWidget {
  const CalmZoneTestScreen({super.key});

  @override
  State<CalmZoneTestScreen> createState() => _CalmZoneTestScreenState();
}

class _CalmZoneTestScreenState extends State<CalmZoneTestScreen>
    with SingleTickerProviderStateMixin {
  int index = 0;
  List<int?> answers = [];

  late AnimationController controller;
  late Animation<double> fade;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();

    answers = List.filled(mentalTestData.length, null);

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    fade = Tween(begin: 0.0, end: 1.0).animate(controller);
    slide = Tween(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(controller);

    controller.forward();
  }

  void next() {
    if (answers[index] == null) return;

    if (index < mentalTestData.length - 1) {
      controller.reset();
      setState(() => index++);
      controller.forward();
    } else {
      _showResult();
    }
  }

  void back() {
    if (index == 0) return;

    controller.reset();
    setState(() => index--);
    controller.forward();
  }

  // ============================================================
  // COMBINED SCORING — PERCENTAGE OUT OF 100
  // ============================================================

  // Max possible: PHQ-9 = 27, GAD-7 = 21, Total = 48

  int phqMaxScore = 27;
  int gadMaxScore = 21;
  int totalMaxScore = 48; // 27 + 21

  Map<String, dynamic> calculateMentalHealthResult(List<int> selectedScores) {
    // selectedScores: 16 values, index 0–8 = PHQ-9, index 9–15 = GAD-7

    int phq9Score = 0;
    for (int i = 0; i <= 8; i++) {
      phq9Score += selectedScores[i];
    }

    int gad7Score = 0;
    for (int i = 9; i <= 15; i++) {
      gad7Score += selectedScores[i];
    }

    int combinedScore = phq9Score + gad7Score;

    // Percentage out of 100
    double percentage = (combinedScore / totalMaxScore) * 100;
    double roundedPercentage = double.parse(percentage.toStringAsFixed(1));

    // Severity label based on percentage
    String severity;
    int severityColor;

    if (roundedPercentage <= 16) {
      severity = "Minimal";
      severityColor = 0xFF4CAF50; // Green
    } else if (roundedPercentage <= 37) {
      severity = "Mild";
      severityColor = 0xFFFFEB3B; // Yellow
    } else if (roundedPercentage <= 58) {
      severity = "Moderate";
      severityColor = 0xFFFF9800; // Orange
    } else if (roundedPercentage <= 79) {
      severity = "Moderately Severe";
      severityColor = 0xFFFF5722; // Deep Orange
    } else {
      severity = "Severe";
      severityColor = 0xFFF44336; // Red
    }

    return {
      "phq9Score": phq9Score, // internal
      "gad7Score": gad7Score, // internal
      "combinedScore": combinedScore, // internal
      "totalMaxScore": totalMaxScore, // 48
      "percentage": roundedPercentage, // e.g. 65.0
      "severity": severity, // e.g. "Moderate"
      "color": severityColor, // Flutter Color hex
      "displayResult":
          "$roundedPercentage% — $severity", // e.g. "65.0% — Moderate"
    };
  }

  // double getPercent() {
  //   int max = mentalTestData.length * 3;
  //   int total = answers.fold(0, (a, b) => a + (b ?? 0));
  //   return (total / max) * 100;
  // }

  String getLevel(double p) {
    if (p <= 30) return "Low (Beginner)";
    if (p <= 60) return "Moderate (Intermediate)";
    return "High (Severe)";
  }

  void _showResult() {
    final result = calculateMentalHealthResult(
      answers.map((e) => e ?? 0).toList(),
    );

    double percent = result["percentage"] as double;
    String severity = result["severity"] as String;
    int phqScore = result["phq9Score"] as int;
    int gadScore = result["gad7Score"] as int;
    int combinedScore = result["combinedScore"] as int;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Constants.getSurfaceColor(
          Theme.of(context).brightness == Brightness.dark,
        ),
        title: Text(
          "Your CalmZone Result",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Score: ${percent.toStringAsFixed(1)}%"),
            const SizedBox(height: 8),
            Text(
              "Level: ${getLevel(percent)}",
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: Constants.accentColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                index = 0;
                answers = List.filled(mentalTestData.length, null);
              });
            },
            child: const Text("Restart"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.accentColor,
            ),
            onPressed: () async {
              await TestStorage.saveResult(
                percentageValue: percent,
                severityValue: severity,
                phqScore: phqScore,
                gadScore: gadScore,
                combinedScore: combinedScore,
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = mentalTestData[index];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Constants.getBackgroundColor(isDark),
      appBar: AppBar(
        backgroundColor: Constants.getSurfaceColor(isDark),
        title: Text(
          "CalmZone Check-in",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (index + 1) / mentalTestData.length,
              color: Constants.accentColor,
              backgroundColor: Colors.grey.withOpacity(0.2),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: slide,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Q${index + 1}. ${question['question']}",
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Constants.getTextColor(isDark),
                        ),
                      ),

                      const SizedBox(height: 20),

                      ...List.generate(question['options'].length, (i) {
                        final opt = question['options'][i];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Constants.getSurfaceColor(isDark),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: answers[index] == opt['score']
                                  ? Constants.accentColor
                                  : Colors.transparent,
                            ),
                          ),
                          child: RadioListTile<int>(
                            value: opt['score'],
                            groupValue: answers[index],
                            title: Text(
                              opt['text'],
                              style: GoogleFonts.outfit(),
                            ),
                            activeColor: Constants.accentColor,
                            onChanged: (val) {
                              setState(() {
                                answers[index] = val;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            Row(
              children: [
                if (index > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: back,
                      child: const Text("Back"),
                    ),
                  ),

                if (index > 0) const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.accentColor,
                    ),
                    onPressed: next,
                    child: Text(
                      index == mentalTestData.length - 1 ? "Finish" : "Next",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
