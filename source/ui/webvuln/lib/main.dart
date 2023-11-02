import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:webvuln/views/historyScreen.dart';
import 'package:webvuln/views/resourcesScreen.dart';
import 'package:webvuln/views/resultScreen.dart';
import 'package:webvuln/views/scanScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';

// import '../views/scanScreen2.dart';
// import 'views/draft.dart';

void main() {
  runApp(const mainScreen());
}

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file
class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  @override
  int _selectedIndex = 0;
  List _selectedItem = [
    const scanScreen(),
    const resultScreen(),
    const historyScreen(),
    const resourceScreen()
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double heightWidth = MediaQuery.of(context).size.height;
    int numberPage = 0;
    Get.testMode = true;
    return GetMaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            Container(
              width: 150,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: Color(0xFFDCE8F6)),
              child: NavigationRail(
                  backgroundColor: Color(0xFF080848),
                  indicatorShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  leading: Container(
                      width: 150,
                      height: 200,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Image.asset('lib/assets/logo.png'),
                          Text(
                            'WEB VULN',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                  trailing: ElevatedButton(
                      onPressed: () {}, child: Icon(Icons.settings)),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Ionicons.scan_sharp),
                      label: Text('scan'),
                    ),
                    NavigationRailDestination(
                        icon: Icon(Ionicons.analytics), label: Text('result')),
                    NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.clockRotateLeft),
                        label: Text('History')),
                    NavigationRailDestination(
                        icon: LineIcon.addressBook(), label: Text('Resources'))
                  ],
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                      numberPage = _selectedIndex;
                      print(numberPage);
                      print(_selectedIndex);
                    });
                  }),
            ),
            StreamBuilder<int>(
              stream: _selectedIndexStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: screenWidth - 150,
                    height: heightWidth,
                    // margin: EdgeInsetsDirectional.symmetric(horizontal: 20),
                    // padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                    child: _selectedItem[snapshot.data as int],
                  );
                } else {
                  return Container(
                    width: 1000,
                    height: 1000,
                    child: _selectedItem[0],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Stream<int> get _selectedIndexStream =>
      Stream.fromFuture(Future.delayed(const Duration(milliseconds: 100), () {
        return _selectedIndex;
      }));
}
