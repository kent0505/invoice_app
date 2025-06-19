import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';

class ClientImportContact extends StatelessWidget {
  const ClientImportContact({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Button(
        onPressed: onPressed,
        child: const Center(
          child: Text(
            'Import from Contacts',
            style: TextStyle(
              color: Color(0xffFF4400),
              fontSize: 12,
              fontFamily: AppFonts.w400,
            ),
          ),
        ),
      ),
    );
  }
}
