import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/views/history.dart';
import 'package:webvuln/views/resources.dart';
import 'package:webvuln/views/scan.dart';
import 'package:webvuln/views/setting.dart';



Future main() async {
  //execute();
  runApp(
    const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: mainScreen(),
    );
  }
}

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});
  @override
  State<mainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<mainScreen> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF03112e),
        body: Row(
          children: [
            //Drawer Bar
            SizedBox(
                width: screenWidth * 0.13,
                height: double.infinity,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset('lib/assets/logo.png',
                          fit: BoxFit.scaleDown),
                    ),
                    for (int i = 0; i < _listButton.length; i++)
                    Column(
                      children: [
                        _buildButton(
                          onPressed: () {
                            setState(() => _selectedIndex = i);
                          },
                          icon: 'lib/assets/${_listButton[i].toLowerCase()}.png',
                          name: _listButton[i],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                )),
            // Gradient background
            Container(
              width: screenWidth - (screenWidth * 0.13),
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

  ElevatedButton _buildButton({required Function() onPressed,required String icon,required String name}) {

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
                style: GoogleFonts.montserrat(fontSize:16,fontWeight:FontWeight.w600,color:Colors.white),
              ),
            )
          ],
        ));
  }
}
