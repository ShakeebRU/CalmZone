import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomStepper extends StatelessWidget {
  final List<bool> activeStep;
  final Axis direction;
  final List<StepData> steps;
  final Color activeStepColor;
  final Color finishedStepColor;
  final Color unreachedStepColor;
  final Color textColor;
  final double stepRadius;
  final double lineLength;
  final EdgeInsets internalPadding;

  const CustomStepper({
    super.key,
    required this.activeStep,
    required this.steps,
    this.direction = Axis.vertical,
    required this.activeStepColor,
    required this.finishedStepColor,
    required this.unreachedStepColor,
    required this.textColor,
    this.stepRadius = 16,
    this.lineLength = 30,
    this.internalPadding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.asMap().entries.map((entry) {
        int index = entry.key;
        StepData step = entry.value;

        Color stepColor = activeStepColor;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: internalPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: stepRadius,
                    backgroundColor: stepColor,
                    child: CircleAvatar(
                      radius: stepRadius - 1,
                      backgroundColor: activeStep[index]
                          ? Colors.white
                          : stepColor,
                      child: Icon(
                        Icons.check,
                        size: 15,
                        color: activeStep[index] ? stepColor : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      step.title,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (index < steps.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: stepRadius - 2),
                child: DottedLine(
                  direction: Axis.vertical,
                  dotSize: 4.0,
                  spacing: 8.0,
                  color: stepColor,
                  count: 3,
                ),
              ),
            // Container(
            //   height: lineLength,
            //   width: 2,
            //   color: stepColor,
            //   margin: const EdgeInsets.symmetric(horizontal: 5),
            // ),
          ],
        );
      }).toList(),
    );
  }
}

class StepData {
  final String title;

  StepData({required this.title});
}

class DottedLine extends StatelessWidget {
  final Axis direction;
  final double dotSize;
  final double spacing;
  final Color color;
  final int count;

  const DottedLine({
    super.key,
    this.direction = Axis.horizontal,
    this.dotSize = 4.0,
    this.spacing = 6.0,
    this.color = Colors.black,
    this.count = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(count, (index) {
        return Container(
          width: dotSize,
          height: dotSize,
          margin: EdgeInsets.only(bottom: index < count - 1 ? spacing : 0),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );
      }),
    );
  }
}
