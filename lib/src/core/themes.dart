import 'package:flutter/material.dart';

import 'constants.dart';

final theme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  fontFamily: AppFonts.w400,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xff095EF1),
    selectionColor: Color(0xff095EF1),
    selectionHandleColor: Color(0xff095EF1),
  ),

  // OVERSCROLL
  colorScheme: const ColorScheme.light(
    surface: Color(0xffF3F3F1), // bg color when push
    secondary: Color(0xff94A3B8), // overscroll
  ),

  // SCAFFOLD
  scaffoldBackgroundColor: const Color(0xffF3F3F1),

  // APPBAR
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffF3F3F1),
    centerTitle: true,
    toolbarHeight: 64, // app bar size
    elevation: 0,
    actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    titleTextStyle: TextStyle(
      color: Color(0xff151515),
      fontSize: 16,
      fontFamily: AppFonts.w600,
    ),
  ),

  // DIALOG
  dialogTheme: const DialogThemeData(
    insetPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),

  // TEXTFIELD
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    hintStyle: const TextStyle(
      color: Color(0xff707883),
      fontSize: 14,
      fontFamily: AppFonts.w500,
    ),
  ),
);
