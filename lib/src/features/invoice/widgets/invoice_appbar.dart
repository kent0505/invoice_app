import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';

class InvoiceAppbar extends StatelessWidget implements PreferredSizeWidget {
  const InvoiceAppbar({
    super.key,
    required this.title,
    required this.onPreview,
  });

  final String title;
  final VoidCallback onPreview;

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).viewPadding.top,
        ),
        Row(
          children: [
            const SizedBox(width: 16),
            Button(
              onPressed: () {
                try {
                  context.pop();
                } catch (e) {
                  logger(e);
                }
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: AppFonts.w400,
                ),
              ),
            ),
            const Spacer(),
            Button(
              onPressed: onPreview,
              child: const Text(
                'Preview',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: AppFonts.w400,
                ),
              ),
            ),
            // const SizedBox(width: 30),
            // Button(
            //   onPressed: onDone,
            //   child: const Text(
            //     'Done',
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 14,
            //       fontFamily: AppFonts.w600,
            //     ),
            //   ),
            // ),
            const SizedBox(width: 16),
          ],
        ),
        Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontFamily: AppFonts.w600,
            ),
          ),
        ),
      ],
    );
  }
}
