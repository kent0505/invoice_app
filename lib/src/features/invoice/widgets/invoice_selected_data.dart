import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';

class InvoiceSelectedData extends StatelessWidget {
  const InvoiceSelectedData({
    super.key,
    required this.title,
    this.amount = 1,
    required this.onPressed,
  });

  final String title;
  final int amount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: AppFonts.w600,
              ),
            ),
          ),
          if (amount > 1)
            Text(
              'x$amount',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: AppFonts.w600,
              ),
            ),
          const SizedBox(width: 16),
          Button(
            onPressed: onPressed,
            minSize: 40,
            child: const Icon(
              Icons.close_rounded,
              color: Color(0xffFF4400),
            ),
          ),
        ],
      ),
    );
  }
}
