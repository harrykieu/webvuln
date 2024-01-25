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
import 'package:flutter_dotenv/flutter_dotenv.dart';

///TODO: get all function to a class (enum)
execute() async {
  // BUG: can't execute file
  try {
    var result = await Process.run('webvuln.exe', [],
        runInShell: true, workingDirectory: 'F:/webvuln/dist');
    print(
        'Exit code: ${result.exitCode}\nstdout: ${result.stdout}\nstderr: ${result.stderr}');
  } catch (error) {
    print('Error: $error');
  }
}

changeTheme(change) =>
    change == true ? AppTheme.darkTheme : AppTheme.lightTheme;

Future main() async {
  //execute();
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingProvider(),
      child: const MyApp(),
    ),
  );
}

// BUG: cant receive data from socket

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData changeMode = AppTheme.lightTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  Widget empty = const SizedBox(
    height: 20,
  );
  final List<String> _listButton = ['Scan', 'History', 'Resources', 'Settings'];
  final List _selectedItem = [
    const ScanScreen(),
    const HistoryScreen(),
    const ResourceScreen(),
    const SettingScreen()
  ];

  @override
  initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF03112e),
        body: Row(
          children: [
            //Drawer Bar
            Container(
                width: screenWidth * 0.13,
                height: double.infinity,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset('lib/assets/logo.png',
                          fit: BoxFit.scaleDown),
                    ),
                    button(
                        onPressed: () {
                          setState(() => _selectedIndex = 0);
                        },
                        icon: 'lib/assets/scanner.png',
                        name: _listButton[0]),
                    empty,
                    button(
                        onPressed: () {
                          setState(() => _selectedIndex = 1);
                        },
                        icon: 'lib/assets/history.png',
                        name: _listButton[1]),
                    empty,
                    button(
                        onPressed: () {
                          setState(() => _selectedIndex = 2);
                        },
                        icon: 'lib/assets/resources.png',
                        name: _listButton[2]),
                    empty,
                    button(
                        onPressed: () {
                          setState(() => _selectedIndex = 3);
                        },
                        icon: 'lib/assets/settings.png',
                        name: _listButton[3]),
                  ],
                )),
            // Gradient background
            Container(
              width: screenWidth - (screenWidth * 0.13),
              height: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
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
            foregroundColor: Theme.of(context).colorScheme.secondary),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(icon),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          ],
        ));
  }
}
