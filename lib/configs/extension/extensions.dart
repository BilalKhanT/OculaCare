import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  ThemeData get appTheme => Theme.of(this);
}