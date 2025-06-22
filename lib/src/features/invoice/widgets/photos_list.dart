import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../models/photo.dart';
import '../screens/photo_screen.dart';

class PhotosList extends StatelessWidget {
  const PhotosList({super.key, required this.photos});

  final List<Photo> photos;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(
        photos.length,
        (index) {
          return Button(
            onPressed: () {
              context.push(
                PhotoScreen.routePath,
                extra: photos[index],
              );
            },
            child: Image.file(
              File(photos[index].path),
              height: (MediaQuery.sizeOf(context).width / 3) - 11,
              width: (MediaQuery.sizeOf(context).width / 3) - 11,
              fit: BoxFit.cover,
              frameBuilder: ImageWidget.frameBuilder,
              errorBuilder: ImageWidget.errorBuilder,
            ),
          );
        },
      ),
    );
  }
}
