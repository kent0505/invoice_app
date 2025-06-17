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
    surface: Color(0xffF2F5F8), // bg color when push
    secondary: Color(0xffd5d5d5), // overscroll
  ),

  // SCAFFOLD
  scaffoldBackgroundColor: const Color(0xffF2F5F8),

  // APPBAR
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffF2F5F8),
    centerTitle: true,
    toolbarHeight: 64, // app bar size
    elevation: 0,
    actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
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
