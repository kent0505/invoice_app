import 'package:flutter/material.dart';

import '../constants.dart';

class SnackWidget {
  static void show(
    BuildContext context, {
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.only(bottom: 100),
        behavior: SnackBarBehavior.floating,
        content: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Color(0xffFF4400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: AppFonts.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
