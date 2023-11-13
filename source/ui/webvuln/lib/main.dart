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
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 0;
                              });
                            },
                            child: const Column(
                              children: [Icon(Ionicons.scan), Text('Scan')],
                            ),
                            style: ElevatedButton.styleFrom(
                                maximumSize: const Size(100, 100))),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          child: const Column(
                            children: [
                              Icon(Ionicons.analytics),
                              Text('Result Scan')
                            ],
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 2;
                              });
                            },
                            child: const Column(
                              children: [
                                Icon(Ionicons.accessibility),
                                Text('Resource')
                              ],
                            )),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 3;
                            });
                          },
                          child: const Column(
                            children: [
                              Icon(Ionicons.hammer_sharp),
                              Text('History')
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 4;
                            });
                          },
                          child: const Column(
                            children: [
                              Icon(Ionicons.settings),
                              Text('Setting')
                            ],
                          ),
                        )
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
              decoration:const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                gradient: LinearGradient(
                  begin:AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.center,
                colors: [
                  Color(0xFF0620A6),
                  Color(0xFFF0F0F0)
                ])
              ),
              child: _selectedItem[_selectedIndex],
            )
          ],
        ),
      ),
    );
  }

  Stream<int> get _selectedIndexStream =>
      Stream.fromFuture(Future.delayed(const Duration(milliseconds: 500), () {
        return _selectedIndex;
      }));
}
