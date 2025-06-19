import 'package:flutter/material.dart';

import 'button.dart';

class SwitchButton extends StatelessWidget {
  const SwitchButton({
    super.key,
    required this.isActive,
    required this.onPressed,
  });

  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 22,
        width: 40,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xffFF4400) : const Color(0xffE8E8E9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Button(
          onPressed: onPressed,
          minSize: 22,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                top: 3,
                left: isActive ? 21 : 3,
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
