import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/historyScreen.dart';
import 'package:webvuln/views/resourcesScreen.dart';
import 'package:webvuln/views/resultScreen.dart';
import 'package:webvuln/views/scanScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:webvuln/views/settingScreen.dart';

// import '../views/scanScreen2.dart';
// import 'views/draft.dart';

void main() {
  runApp(const mainScreen());
}

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = 0;
  }

  @override
  int _selectedIndex = 0;
  final List _selectedItem = [
    const scanScreen(),
    const resultScreen(),
    const resourceScreen(),
    const historyScreen(),
    const settingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double heightWidth = MediaQuery.of(context).size.height;
    Get.testMode = true;
    return GetMaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF03112e),
        body: Row(
          children: [
            Container(
              width: screenWidth * 0.13,
              height: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Image.asset('lib/assets/logo.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        button(
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 0;
                              });
                            },
                            icon: Icons.abc,
                            name: 'Scan'),
                        SizedBox(height: 20,),
                        button(
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 1;
                              });
                            },
                            icon: Icons.ac_unit,
                            name: 'Result'),
                            SizedBox(height: 20,),
                        button(
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 2;
                              });
                            },
                            icon: Icons.access_alarm_rounded,
                            name: 'Resource'),
                            SizedBox(height: 20,),
                        button(
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 3;
                              });
                            },
                            icon: Icons.accessibility_rounded,
                            name: 'History'),
                            SizedBox(height: 20,),
                        button(
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 4;
                              });
                            },
                            icon: Icons.ad_units_sharp,
                            name: 'Settings')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: screenWidth * 0.87,
              height: double.infinity,
              // color: Colors.black,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30)),
                  gradient: LinearGradient(
                      begin: AlignmentDirectional.topCenter,
                      end: AlignmentDirectional.center,
                      colors: [Color(0xFF0620A6), Color(0xFFF0F0F0)])),
              child: _selectedItem[_selectedIndex],
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton button(
      {required Function() onPressed,
      required IconData icon,
      required String name}) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Column(
          children: [Icon(icon), Text(name)],
        ),
        style: ElevatedButton.styleFrom(minimumSize: const Size(200, 80),backgroundColor: Colors.transparent,foregroundColor: Colors.white));
  }

  Stream<int> get _selectedIndexStream =>
      Stream.fromFuture(Future.delayed(const Duration(milliseconds: 500), () {
        return _selectedIndex;
      }));
}
