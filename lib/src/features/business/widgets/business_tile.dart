import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../bloc/business_bloc.dart';
import '../models/business.dart';

class BusinessTile extends StatefulWidget {
  const BusinessTile({
    super.key,
    required this.business,
    required this.onPressed,
  });

  final Business business;
  final VoidCallback onPressed;

  @override
  State<BusinessTile> createState() => _BusinessTileState();
}

class _BusinessTileState extends State<BusinessTile> {
  bool delete = false;

  void onMenu() {
    setState(() {
      delete = !delete;
    });
  }

  void onBusiness() {
    if (delete) {
      onMenu();
    } else {
      widget.onPressed();
    }
  }

  void onDelete() {
    DialogWidget.show(
      context,
      title: 'Delete?',
      delete: true,
      onPressed: () {
        context
            .read<BusinessBloc>()
            .add(DeleteBusiness(business: widget.business));
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Button(
                  onPressed: onBusiness,
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xffFF4400),
                        ),
                        child: widget.business.imageLogo.isEmpty
                            ? const Center(
                                child: SvgWidget(Assets.user),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(56),
                                child: Image.file(
                                  File(widget.business.imageLogo),
                                  fit: BoxFit.cover,
                                  errorBuilder: ImageWidget.errorBuilder,
                                  frameBuilder: ImageWidget.frameBuilder,
                                ),
                              ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.business.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: AppFonts.w600,
                              ),
                            ),
                            Text(
                              widget.business.email,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: AppFonts.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Button(
                onPressed: onMenu,
                child: const SvgWidget(Assets.menu),
              ),
            ],
          ),
          if (delete)
            Positioned(
              top: 25,
              bottom: 25,
              right: 40,
              child: Button(
                onPressed: onDelete,
                child: Container(
                  height: 35,
                  width: 144,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Delete account',
                        style: TextStyle(
                          color: Color(0xffFF6464),
                          fontSize: 12,
                          fontFamily: AppFonts.w400,
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: 20,
                        child: SvgWidget(Assets.delete),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
