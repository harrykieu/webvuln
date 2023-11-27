import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class ChartData {
  final String x;
  final num y;
  final num y1;

  ChartData(this.x, this.y, this.y1);
}

class lineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    TextStyle text_style_title = GoogleFonts.montserrat(
        fontSize: 24, color: Colors.black, fontWeight: FontWeight.w600);
    TextStyle text_style_normal = GoogleFonts.montserrat(
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal);

    final List<ChartData> chartData = [
      ChartData('XSS', 48, 67),
      ChartData('SQLi', 80, 34),
      ChartData('LFI', 14, 23),
      ChartData('RCE', 11, 18),
      ChartData('XXE', 20, 12)
    ];

    return Container(
      width: screenWidth / 3,
      height: 600,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Title line chart
          ListTile(
            title: Row(
              children: [
                const Image(image: AssetImage('lib/assets/LineChart.png')),
                Row(
                  children: [
                    const Text(
                      '   Line Chart',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    tool_tip(content: 'Info about line chart')
                  ],
                )
              ],
            ),
          ),
          // Line chart
          SfCartesianChart(
              trackballBehavior: TrackballBehavior(enable: true),
              legend: const Legend(isVisible: false),
              tooltipBehavior: TooltipBehavior(enable: true),
              plotAreaBorderWidth: 0,
              primaryXAxis:
                  CategoryAxis(), // Change to CategoryAxis since x values are strings
              series: <ChartSeries>[
                ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y)
              ]),
          Container(
            width: double.infinity,
            height: 150,
            margin: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: Text(chartData[0].x+" Percent of all:",style: text_style_title,),
                    title: Text(chartData[0].y.toString()+"%",style: text_style_normal,),
                  ),
                  ListTile(
                    leading: Text(chartData[1].x+" Percent of all:",style: text_style_title,),
                    title: Text(chartData[1].y.toString()+"%",style: text_style_normal,),
                  ),
                  ListTile(
                    leading: Text(chartData[2].x+" Percent of all:",style: text_style_title,),
                    title: Text(chartData[2].y.toString()+"%",style: text_style_normal,),
                  ),
                  ListTile(
                    leading: Text(chartData[3].x+" Percent of all:",style: text_style_title,),
                    title: Text(chartData[3].y.toString()+"%",style: text_style_normal,),
                  ),
                  ListTile(
                    leading: Text(chartData[4].x+" Percent of all:",style: text_style_title,),
                    title: Text(chartData[4].y.toString()+"%",style: text_style_normal,),
                  )
              
                ],
              ),
            ),
          )
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
            Icons.info_outline_rounded,
            color: Colors.black,
            size: 16,
          ),
    );
  }
}

