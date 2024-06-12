import 'package:driver_app/screens/chart/bar_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyBarGraph extends StatelessWidget {
  final List<double> gasolineTotal;
  const MyBarGraph({super.key, required this.gasolineTotal});

  @override
  Widget build(BuildContext context) {
    // Initialize bar data
    BarData myBarData = BarData(
      ron95Amount: gasolineTotal[0],
      ron92Amount: gasolineTotal[1],
      doAmout: gasolineTotal[2],
    );
    myBarData.initalizeBarData();

    // Define colors for each bar
    List<Color> barColors = [
      const Color.fromRGBO(58, 158, 252, 1), // Blue
      const Color.fromRGBO(30, 187, 77, 1), // Green
      const Color.fromRGBO(228, 52, 52, 1), // Yellow
    ];

    return BarChart(
      BarChartData(
        maxY: 6000,
        minY: 0,
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles:
                SideTitles(showTitles: true, getTitlesWidget: getBottomTitles),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x.toInt(),
                barRods: [
                  // Create BarChartRodData for each bar

                  BarChartRodData(
                    toY: data.y,
                    color:
                        barColors[data.x.toInt()], // Assign color from the list
                    width: 24,
                    borderRadius: BorderRadius.circular(0),
                  ),
                ],
              ),
            )
            .toList(), // Convert Iterable to List
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color.fromRGBO(49, 52, 66, 1),
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  Widget text = const SizedBox(); // Provide an initial value for text

  switch (value.toInt()) {
    case 0:
      text = const Text('RON 95', style: style);
      break;
    case 1:
      text = const Text('RON 92', style: style);
      break;
    case 2:
      text = const Text('DO 0,05S-II', style: style);
      break;
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
