import 'package:flutter/material.dart';

const standardElevation = 5.0;
const borderDouble = 8.0;
BorderRadius standardBorderRadius = BorderRadius.circular(borderDouble);

getTabColor(
  BuildContext context,
  bool selected,
) {
  Color selectedColor = Colors.black;
  Color notSelectedColor = selectedColor.withOpacity(0.5);

  return selected ? selectedColor : notSelectedColor;
}

const primaryColor = Colors.blue;

