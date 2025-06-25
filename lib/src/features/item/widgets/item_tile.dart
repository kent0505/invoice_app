import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../settings/data/settings_repository.dart';
import '../models/item.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.item,
    required this.onPressed,
  });

  final Item item;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final discountPrice = double.tryParse(item.discountPrice) ?? 0;
    final taxPercent = double.tryParse(item.tax) ?? 0;
    final total = discountPrice + discountPrice * (taxPercent / 100);
    final currency = context.read<SettingsRepository>().getCurrency();

    return Button(
      onPressed: onPressed,
      child: Container(
        height: 44,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: Color(0xff7D81A3),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: AppFonts.w400,
                ),
              ),
            ),
            Text(
              '$currency${total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xff7D81A3),
                fontSize: 14,
                fontFamily: AppFonts.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
