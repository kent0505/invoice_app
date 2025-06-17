import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils.dart';

class SvgWidget extends StatelessWidget {
  const SvgWidget(
    this.assetName, {
    super.key,
    this.height,
    this.width,
    this.color,
  });

  final String assetName;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      height: height,
      width: width,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            ),
      placeholderBuilder: (context) {
        return SizedBox(
          height: height,
          width: width,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        logger(error);
        return const SizedBox();
      },
    );
  }
}
