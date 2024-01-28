import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_run/process_run.dart';
import 'package:webvuln/views/history.dart';
import 'package:webvuln/views/resources.dart';
import 'package:webvuln/views/scan.dart';
import 'package:webvuln/views/setting.dart';

void main() {
  execute();
  runApp(const MyApp());
}

void execute(){
  try {
    var shell = Shell();
    shell.run('cd ../../../ & python webvuln.py');
    print('\n [Logs Backend]:\n${shell.toString()}');
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<String> _listButton = ['Scan', 'History', 'Resources', 'Settings'];
  final List<Widget> _selectedItem = [
    const ScanScreen(),
    const HistoryScreen(),
    const ResourceScreen(),
    const SettingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Get.testMode = true;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF03112e),
        body: Row(
          children: [
            // Drawer Bar
            Container(
              width: screenWidth * 0.16,
              height: double.infinity,
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Image.asset('lib/assets/logo.png',
                        fit: BoxFit.scaleDown),
                  ),
                  for (int i = 0; i < _listButton.length; i++)
                    _buildButton(i, screenWidth),
                ],
              ),
            ),
            // Gradient background
            Container(
              width: screenWidth - (screenWidth * 0.16),
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('lib/assets/background.png'),
                ),
              ),
              child: _selectedItem[_selectedIndex],
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildButton(int index, double screenWidth) {
    double paddingSize = MediaQuery.of(context).size.width * 0.005;

    return ElevatedButton(
      onPressed: () {
        setState(() => _selectedIndex = index);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(screenWidth * 0.1, 80),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(paddingSize),
            child: Image.asset(
                'lib/assets/${_listButton[index].toLowerCase()}.png',
                height: 28),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            _listButton[index],
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
