import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../settings/screens/settings_screen.dart';

class TotalIncome extends StatelessWidget {
  const TotalIncome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 16,
      ).copyWith(top: 16 + MediaQuery.of(context).viewPadding.top),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Income',
                  style: TextStyle(
                    color: Color(0xff8E8E93),
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$${100.toStringAsFixed(2)}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontFamily: AppFonts.w800,
                  ),
                ),
              ],
            ),
          ),
          Button(
            child: SvgWidget(Assets.settings),
            onPressed: () {
              context.push(SettingsScreen.routePath);
            },
          ),
        ],
      ),
    );
  }
}
