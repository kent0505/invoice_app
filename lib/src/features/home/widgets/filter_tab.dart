import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';

class FilterTab extends StatelessWidget {
  const FilterTab({
    super.key,
    required this.index,
    required this.current,
    required this.title,
    required this.onPressed,
  });

  final int index;
  final int current;
  final String title;
  final void Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    final active = index == current;

    return Expanded(
      child: Button(
        onPressed: active
            ? null
            : () {
                onPressed(index);
              },
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: active ? const Color(0xffFF4400) : null,
            borderRadius: BorderRadius.circular(6),
            border: active
                ? null
                : Border.all(
                    width: 1,
                    color: const Color(0xff94A3B8),
                  ),
          ),
          child: Center(
            child: FittedBox(
              child: Text(
                title,
                maxLines: 2,
                style: TextStyle(
                  color: active ? Colors.white : const Color(0xff7D81A3),
                  fontSize: 16,
                  fontFamily: AppFonts.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
