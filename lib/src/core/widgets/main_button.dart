import 'package:flutter/material.dart';

import '../constants.dart';
import 'button.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.title,
    this.width,
    this.horizontal = 0,
    this.active = true,
    this.outlined = false,
    required this.onPressed,
  });

  final String title;
  final double? width;
  final double horizontal;
  final bool active;
  final bool outlined;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 44,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: horizontal),
      decoration: BoxDecoration(
        color: outlined
            ? null
            : (active ? const Color(0xffFF4400) : const Color(0xff94A3B8)),
        border: outlined
            ? Border.all(
                width: 1,
                color: const Color(0xffFF4400),
              )
            : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Button(
        onPressed: active ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: outlined ? const Color(0xffFF4400) : Colors.white,
                fontSize: 12,
                fontFamily: AppFonts.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainButtonWrapper extends StatelessWidget {
  const MainButtonWrapper({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16).copyWith(
        bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
