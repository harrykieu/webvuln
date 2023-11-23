import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class lineChart extends StatefulWidget {
  const lineChart({super.key});

  @override
  State<lineChart> createState() => _lineChartState();
}

class _lineChartState extends State<lineChart> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<LineChartData> dataLineChart = [LineChartData(maxX: 100, minX: 10)];
    return Container(
      width: 500,
      height: 600,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(0, 4),
              blurRadius: 10,
            )
          ]),
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Image(image: AssetImage('lib/assets/LineChart.png')),
                Text(
                  '   Line Chart',
                  style: GoogleFonts.montserrat(
                      fontSize: 24, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          // MyLineChart()
        ],
      ),
    );
  }
}

class MyLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(drawBelowEverything: true),
            bottomTitles: AxisTitles(drawBelowEverything: true)),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color(0xff37434d),
            width: 1,
          ),
        ),
        minX: 0,
        maxX: 7,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 3),
              FlSpot(1, 1),
              FlSpot(2, 4),
              FlSpot(3, 2),
              FlSpot(4, 5),
              FlSpot(5, 1),
              FlSpot(6, 4),
            ],
            isCurved: true,
            // color: [Colors.blue,Colors.accents],
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
