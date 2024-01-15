// ignore_for_file: camel_case_types, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:webvuln/themes/app_themes.dart';
import 'package:webvuln/views/history.dart';
import 'package:webvuln/views/resources.dart';
import 'dart:io';
import 'package:webvuln/views/scan.dart';
import 'package:webvuln/views/setting.dart';

execute() async {
  try {
    var result = await Process.run('webvuln.exe', [],
        runInShell: true, workingDirectory: 'F:/webvuln/dist');
    print(
        'Exit code: ${result.exitCode}\nstdout: ${result.stdout}\nstderr: ${result.stderr}');
  } catch (error) {
    print('Error: $error');
  }
}

changeTheme(change) {
  if (change == true) {
    return AppTheme.darkTheme;
  } else {
    return AppTheme.lightTheme;
  }
}

main() {
  execute();
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingProvider(),
      child: const MyApp(),
    ),
  );
}

class MyAppProvider extends ChangeNotifier {
  /// Toggle for dark mode
  bool _isDarkMode = false;

  change() {
    /// Toggle dark mode value
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData changeMode = AppTheme.lightTheme;
    return MaterialApp(
      // themeMode: ThemeMode.system,
      theme: changeMode,
      home: const mainScreen(),
    );
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
            foregroundColor:
                Theme.of(context as BuildContext).colorScheme.secondary),
        child: Column(
          children: [
            Image(image: AssetImage(icon)),
            Text(
              name,
              style: Theme.of(context as BuildContext).textTheme.bodyLarge,
            )
          ],
        ));
  }
}
