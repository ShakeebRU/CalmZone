import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constants.dart';

class MonthlyProgressChart extends StatelessWidget {
  final bool isDark;

  const MonthlyProgressChart({super.key, required this.isDark});

  // Sample data for the last 7 days
  List<FlSpot> get _spots {
    return [
      const FlSpot(0, 3),
      const FlSpot(1, 4),
      const FlSpot(2, 5),
      const FlSpot(3, 3.5),
      const FlSpot(4, 6),
      const FlSpot(5, 5.5),
      const FlSpot(6, 7),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Constants.getBorderColor(isDark).withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      days[value.toInt()],
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        color: Constants.getTextSecondaryColor(isDark),
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: Constants.getTextSecondaryColor(isDark),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
              color: Constants.getBorderColor(isDark).withOpacity(0.3),
            ),
            left: BorderSide(
              color: Constants.getBorderColor(isDark).withOpacity(0.3),
            ),
          ),
        ),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 8,
        lineBarsData: [
          LineChartBarData(
            spots: _spots,
            isCurved: true,
            color: Constants.accentColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Constants.accentColor.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

