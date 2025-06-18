import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/svg_widget.dart';

class BusinessLogo extends StatelessWidget {
  const BusinessLogo({
    super.key,
    required this.file,
    required this.onPressed,
  });

  final XFile file;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Button(
        onPressed: onPressed,
        child: file.path.isEmpty
            ? const DottedBorder(
                options: RectDottedBorderOptions(
                  dashPattern: [2, 2],
                  strokeWidth: 1,
                  color: Color(0xff8E8E93),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgWidget(Assets.addImage),
                      Text(
                        'Add Logo',
                        style: TextStyle(
                          color: Color(0xff8E8E93),
                          fontSize: 12,
                          fontFamily: AppFonts.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Image.file(
                File(file.path),
                errorBuilder: ImageWidget.errorBuilder,
                frameBuilder: ImageWidget.frameBuilder,
              ),
      ),
    );
  }
}
