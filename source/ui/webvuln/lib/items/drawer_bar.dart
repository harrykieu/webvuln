import 'package:flutter/material.dart';

class drawer_bar extends StatefulWidget {
  drawer_bar({super.key, required this.number_screen});
  @override
  int number_screen;
  State<drawer_bar> createState() => _drawer_barState();
}

class _drawer_barState extends State<drawer_bar> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
        width: screenWidth * 0.13,
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            button(
                onPressed: () {
                  setState(() {
                    widget.number_screen = 1;
                  });
                },
                icon: Icons.scanner,
                name: 'Scan')
          ],
        ));
  }

  ElevatedButton button(
      {required Function() onPressed,
      required IconData icon,
      required String name}) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 80),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white),
        child: Column(
          children: [Icon(icon), Text(name)],
        ));
  }
}
