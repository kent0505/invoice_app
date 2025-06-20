import 'package:flutter/material.dart';

import '../constants.dart';
import 'button.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: const Text(
        '+',
        style: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontFamily: AppFonts.w400,
        ),
      ),
    );
  }
}
