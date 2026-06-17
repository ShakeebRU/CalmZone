import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constants.dart';
import '../constants/mental_test_data.dart';

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

  double getPercent() {
    int max = mentalTestData.length * 3;
    int total = answers.fold(0, (a, b) => a + (b ?? 0));
    return (total / max) * 100;
  }

  String getLevel(double p) {
    if (p <= 30) return "Low (Beginner)";
    if (p <= 60) return "Moderate (Intermediate)";
    return "High (Severe)";
  }

  void _showResult() {
    double percent = getPercent();

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
            onPressed: () => Navigator.pop(context),
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
