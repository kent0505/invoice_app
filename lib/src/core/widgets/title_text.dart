import 'package:flutter/material.dart';

import '../constants.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xff7D81A3),
          fontSize: 12,
          fontFamily: AppFonts.w400,
        ),
      ),
    );
  }
}
