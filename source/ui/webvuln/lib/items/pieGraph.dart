import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:pie_chart/pie_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class containerPieChart extends StatefulWidget {
  const containerPieChart({super.key});

  @override
  State<containerPieChart> createState() => _containerPieChartState();
}

class _containerPieChartState extends State<containerPieChart> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: (screenWidth - 200) / 2.5,
      height: 600,
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5)
          ]),
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                const Image(image: AssetImage('lib/assets/PieChart.png')),
                Text(
                  '  Pie Chart',
                  style: GoogleFonts.montserrat(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                tool_tip(content: 'info about chart 1 ')
              ],
            ),
          ),
          const pieGraph(),
        ],
      ),
    );
  }

  JustTheTooltip tool_tip({required String content}) {
    return JustTheTooltip(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          content,
        ),
      ),
      child: const Icon(
            Icons.info_outline,
            color: Colors.black,
            size: 16,
          ),
    );
  }
}

class pieGraph extends StatefulWidget {
  const pieGraph({super.key});

  @override
  State<pieGraph> createState() => _pieGraphState();
}

class _pieGraphState extends State<pieGraph> {
  int touchedIndex = 0;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // data cua bieu do tron
    List<PieChartSectionData> dataError = [
      PieChartSectionData(
        value: 20,
        color: const Color(0xFF12486B),
        title: "SQLi",
        titleStyle: GoogleFonts.montserrat(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        radius: 80,
      ),
      PieChartSectionData(
        value: 50,
        color: const Color(0xFF713ABE),
        title: 'XSS error',
        titleStyle: GoogleFonts.montserrat(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        radius: 80,
      ),
      PieChartSectionData(
          value: 30,
          color: const Color(0xFF78D6C6),
          title: 'LFI error',
          titleStyle: GoogleFonts.montserrat(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          radius: 80),
      PieChartSectionData(
        value: 30,
        color: const Color(0xFF419197),
        title: 'RCE error',
        titleStyle: GoogleFonts.montserrat(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        radius: 80,
      )
    ];
    // List<Color> colorsList = [Colors.redAccent[700], Colors.orangeAccent[700]];
    return Container(
        width: 0,
        height: 80,
        margin: const EdgeInsets.only(top: 200),
        child: PieChart(
          PieChartData(
            sections: dataError,
            borderData: FlBorderData(
                show: false, border: Border.all(color: Colors.black, width: 2)),
            sectionsSpace: 2,
            startDegreeOffset: 12,
            // centerSpaceRadius: 100,
            centerSpaceRadius: screenWidth / 10,
          ),
          swapAnimationCurve: Curves.bounceInOut,
          swapAnimationDuration: const Duration(milliseconds: 100),
        ));
  }
}
