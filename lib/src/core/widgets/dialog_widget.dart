import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import 'button.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({
    super.key,
    required this.title,
    this.delete = false,
    this.onPressed,
  });

  final String title;
  final bool delete;
  final VoidCallback? onPressed;

  static void show(
    BuildContext context, {
    required String title,
    bool delete = false,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (context) {
        return DialogWidget(
          title: title,
          delete: delete,
          onPressed: onPressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 270,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: AppFonts.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (delete) ...[
                    _Button(
                      title: 'No',
                      color: Colors.black,
                      fontFamily: AppFonts.w500,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    _Button(
                      title: 'Yes',
                      color: Colors.black,
                      fontFamily: AppFonts.w500,
                      onPressed: onPressed ??
                          () {
                            context.pop();
                          },
                    ),
                  ] else
                    _Button(
                      title: 'OK',
                      color: Colors.black,
                      fontFamily: AppFonts.w500,
                      onPressed: onPressed ??
                          () {
                            context.pop();
                          },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.title,
    required this.color,
    required this.fontFamily,
    required this.onPressed,
  });

  final String title;
  final Color color;
  final String fontFamily;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Button(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontFamily: fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
