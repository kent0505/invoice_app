import 'package:flutter/material.dart';

import '../constants.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No data',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: AppFonts.w600,
        ),
      ),
    );
  }
}
