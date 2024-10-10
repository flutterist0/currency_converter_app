import 'package:flutter/material.dart';

Widget customDropDown(
    List<String> items, String value, void Function(String?) onChange) {
  return Container(
    width: 80,
    height: 60,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    ),
    alignment: Alignment.center,
    child: DropdownButton<String>(
      items: items.map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem(
          child: Text(val),
          value: val,
        );
      }).toList(),
      onChanged: (String? newValue) {
        onChange(newValue);
      },
      value: value,
    ),
  );
}
