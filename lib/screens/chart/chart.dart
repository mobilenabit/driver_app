import 'package:driver_app/screens/chart/bar_graph.dart';
import 'package:flutter/material.dart';



class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  // List number of gasoline
  List<double> gasolineTotal = [
    3000,
    1000,
    510,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 271.78,
          width: 271,
          child: MyBarGraph(
            gasolineTotal: gasolineTotal,
          ),
        ),
      ),
    );
  }
}
