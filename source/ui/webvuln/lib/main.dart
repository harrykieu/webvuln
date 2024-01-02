// ignore_for_file: camel_case_types, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:webvuln/views/history.dart';
import 'package:webvuln/views/resources.dart';
import 'package:webvuln/views/scan.dart';
import 'package:webvuln/views/setting.dart';

void main() async {
  //TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const mainScreen());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  int _selectedIndex = 0;
  String scanResult = '';
  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  final List _selectedItem = [
    const ScanScreen(),
    const HistoryScreen(),
    const ResourceScreen(),
    const SettingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Get.testMode = true;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawerEnableOpenDragGesture: false,
        backgroundColor: const Color(0xFF03112e),
        body: Row(
          children: [
            //Drawer Bar
            Drawer(
                width: screenWidth * 0.13,
                backgroundColor: Colors.transparent,
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child:
                          const Image(image: AssetImage('lib/assets/logo.png')),
                    ),
                    button(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        icon: 'lib/assets/scanner.png',
                        name: 'Scan'),
                    const SizedBox(
                      height: 20,
                    ),
                    button(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        icon: 'lib/assets/history.png',
                        name: 'History'),
                    const SizedBox(
                      height: 20,
                    ),
                    button(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                        icon: 'lib/assets/resources.png',
                        name: 'Resources'),
                    const SizedBox(
                      height: 20,
                    ),
                    button(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 3;
                          });
                        },
                        icon: 'lib/assets/settings.png',
                        name: 'Settings'),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )),
            // Gradient background
            Container(
              width: screenWidth - (screenWidth * 0.13),
              // bug: failure in cropping background image
              height: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30)),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('lib/assets/background.png'))),
              child: _selectedItem[_selectedIndex],
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton button(
      {required Function() onPressed,
      required String icon,
      required String name}) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 80),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white),
        child: Column(
          children: [Image(image: AssetImage(icon)), Text(name)],
        ));
  }

/*   Stream<int> get _selectedIndexStream =>
      Stream.fromFuture(Future.delayed(const Duration(milliseconds: 500), () {
        return _selectedIndex;
      })); */
}
