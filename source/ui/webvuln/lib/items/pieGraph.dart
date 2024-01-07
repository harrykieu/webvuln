// ignore_for_file: file_names, must_be_immutable, camel_case_types

import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../themes/app_colors.dart';
import 'indicators.dart';

class containerPieChart extends StatefulWidget {
  String data;
  containerPieChart({super.key, required this.data});

  @override
  State<containerPieChart> createState() => _containerPieChartState();
}

class _containerPieChartState extends State<containerPieChart> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: (screenWidth - 200) / 2.5,
      height: 700,
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black38,
                offset: const Offset(0, 4),
                blurRadius: 10)
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
              ],
            ),
          ),
          PieChartSample1(
            data: widget.data,
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PieChartSample1 extends StatefulWidget {
  PieChartSample1({super.key, required this.data});
  String data;

  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State<PieChartSample1> {
  int touchedIndex = -1;
  bool isVisibled = true;
  double xss = 16;
  double lfi = 16;
  double sqli = 16;
  double rce = 16;
  double xxe = 16;
  //dataMap is json data vulnerabilities
  //data is json data vulnerabilities
  void modify_data(mapData, listData) {}

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> mapData = jsonDecode(widget.data);
    List listVuln = mapData["vulnerabilities"];
    if (listVuln.isEmpty) {
      return Text('No data');
    }
    return Visibility(
        visible: isVisibled,
        child: AspectRatio(
          aspectRatio: 1.3,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Indicator(
                    color: AppColors.contentColorBlue,
                    text: 'XSS',
                    isSquare: false,
                    size: touchedIndex == 0 ? xss + 2 : xss,
                    textColor: touchedIndex == 0
                        ? AppColors.contentColorBlack
                        : AppColors.menuBackground,
                  ),
                  Indicator(
                    color: AppColors.contentColorYellow,
                    text: 'SQLi',
                    isSquare: false,
                    size: touchedIndex == 1 ? sqli + 2 : sqli,
                    textColor: touchedIndex == 1
                        ? AppColors.contentColorBlack
                        : AppColors.menuBackground,
                  ),
                  Indicator(
                    color: AppColors.contentColorPink,
                    text: 'RCE',
                    isSquare: false,
                    size: touchedIndex == 2 ? rce + 2 : rce,
                    textColor: touchedIndex == 2
                        ? AppColors.contentColorBlack
                        : AppColors.menuBackground,
                  ),
                  Indicator(
                    color: AppColors.contentColorGreen,
                    text: 'LFI',
                    isSquare: false,
                    size: touchedIndex == 3 ? lfi + 2 : lfi,
                    textColor: touchedIndex == 3
                        ? AppColors.contentColorBlack
                        : AppColors.menuBackground,
                  ),
                  Indicator(
                    color: AppColors.contentColorCyan,
                    text: 'XXE',
                    isSquare: false,
                    size: touchedIndex == 4 ? xxe + 2 : xxe,
                    textColor: touchedIndex == 4
                        ? AppColors.contentColorBlack
                        : AppColors.menuBackground,
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          print(mapData);
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                          /*mapData: origin json data
                            data_example: json data vulnerabilities
                            isVisibled: appear chart 
                           */
                          // modify(mapData, data_example, isVisibled);
                        },
                      ),
                      startDegreeOffset: 180,
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 1,
                      centerSpaceRadius: 0,
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      5,
      (i) {
        final isTouched = i == touchedIndex;
        const color0 = AppColors.contentColorBlue;
        const color1 = AppColors.contentColorYellow;
        const color2 = AppColors.contentColorPink;
        const color3 = AppColors.contentColorGreen;
        const color4 = AppColors.contentColorCyan;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: 25,
              title: '',
              radius: MediaQuery.of(context).size.width / 12,
              titlePositionPercentageOffset: 1,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1,
              value: 25,
              title: '',
              radius: MediaQuery.of(context).size.width / 12,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: color2,
              value: 25,
              title: '',
              radius: MediaQuery.of(context).size.width / 12,
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: color3,
              value: 25,
              title: '',
              radius: MediaQuery.of(context).size.width / 12,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 4:
            return PieChartSectionData(
              color: color4,
              value: 25,
              title: '',
              radius: MediaQuery.of(context).size.width / 12,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );

          default:
            throw Error();
        }
      },
    );
  }
}
