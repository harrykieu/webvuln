import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class settingScreen extends StatefulWidget {
  const settingScreen({super.key});

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
  @override
  final List<String> items =[
    'PDF','Log'
  ];
  Widget build(BuildContext context) {
    final _controller = ValueNotifier<bool>(false);
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: Center(
          child: Column(
            children: [
              ListTile(
                  title: const Text("Change theme"),
                  trailing: AdvancedSwitch(
                    width: 80,
                    height: 50,
                    controller: _controller,
                    activeChild: Text('Light'),
                    inactiveChild: Text('Dark'),
                    borderRadius: BorderRadius.all(const Radius.circular(10)),
                    enabled: true,
                    disabledOpacity: 0.5,
                  )),
              ListTile(
                title: const Text('Change format export logs'),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(items:
                  items.map((String item) =>DropdownMenuItem(value: item,child: Text(item,style: const TextStyle(fontSize: 16),),) ).toList(),)
                ),
              ),
              ListTile(
                title: Text('Report and feedback'),
                trailing: Container(
                  width: 300,
                  height: 80,
                  child: TextFormField(),
                )
              ),
            ],
          ),
        ));
  }
}
