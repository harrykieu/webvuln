import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:pie_chart/pie_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';



class containerPieChart extends StatefulWidget {
  const containerPieChart({super.key});

  @override
  State<containerPieChart> createState() => _containerPieChartState();
}

class _containerPieChartState extends State<containerPieChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 600,
      margin: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5
          )
        ]
      ),
      child: Column(
        children: [
          ListTile(title: Row(
            children: [
              Image(image: AssetImage('lib/assets/PieChart.png')),
              Text('  Pie Chart',style: GoogleFonts.montserrat(fontSize: 30,fontWeight: FontWeight.bold),)
            ],
          ),),
          pieGraph()
        ],
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
        color: Color(0xFF12486B),
        title: "SQLi",
        titleStyle: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
        radius: 150,
      ),
      PieChartSectionData(
        value: 50,
        color: Color(0xFF713ABE),
        title: 'XSS error',
        titleStyle: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
        radius: 150,
      ),
      PieChartSectionData(
        value: 30,
        color: Color(0xFF78D6C6),
        title: 'LFI error',
        titleStyle: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
        radius: 150
      ),
      PieChartSectionData(
        value: 30,
        color: Color(0xFF419197),
        title: 'RCE error',
        titleStyle: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
        radius: 150,
      )
    ];
    // List<Color> colorsList = [Colors.redAccent[700], Colors.orangeAccent[700]];
    return Container(
        width: 500,
        height: 500,
        child: PieChart(
                PieChartData(
                  sections: dataError,
                  // borderData: FlBorderData(),
                  sectionsSpace: 1,
                  centerSpaceRadius:0,
                ),));
  }
}