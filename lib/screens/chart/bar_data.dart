

class BarData {
  final double ron95Amount;
  final double ron92Amount;
  final double doAmout;

  BarData({
    required this.ron95Amount,
    required this.ron92Amount,
    required this.doAmout,
  });

  List<IndividualBar> barData = [];

  // initialize bar data
  void initalizeBarData() {
    barData = [
      IndividualBar(x: 0, y: ron95Amount),
      IndividualBar(x: 1, y: ron92Amount),
      IndividualBar(x: 2, y: doAmout),
    ];
  }
}

class IndividualBar {
  final double x; // position on x axis
  final double y; // position on y axis

  IndividualBar({
    required this.x,
    required this.y,
  });
}

