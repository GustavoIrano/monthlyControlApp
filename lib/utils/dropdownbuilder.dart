
import 'package:flutter/material.dart';

class DropDownBuilder{
  List _items = [];

  DropDownBuilder(List items){
    _items = items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String item in _items) {
      items.add(new DropdownMenuItem(value: item, child: new Text(item)));
    }

    return items;
  }

}