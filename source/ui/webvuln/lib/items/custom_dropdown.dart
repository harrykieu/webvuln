import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownButton extends StatefulWidget {
  String selectedItem;
  final List<String> items;
  final ValueChanged<String> onItemSelected;

  CustomDropdownButton({
    required this.selectedItem,
    required this.items,
    required this.onItemSelected,
  }) : assert(items.contains(selectedItem));

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: PopupMenuButton<String>(
        offset: Offset(0, 40),
        onSelected: (value) {
          widget.onItemSelected(value);
        },
        itemBuilder: (BuildContext context) {
          return widget.items.map((String item) {
            return PopupMenuItem<String>(
              value: item,
              child: ListTile(
                title: Text(item),
              ),
            );
          }).toList();
        },
        initialValue: widget.selectedItem,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  widget.selectedItem,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
