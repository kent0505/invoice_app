import 'package:flutter/material.dart';

import '../../../core/widgets/divider_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/switch_button.dart';
import '../../../core/widgets/title_text.dart';
import 'item_field.dart';

class ItemBody extends StatelessWidget {
  const ItemBody({
    super.key,
    required this.select,
    required this.saveToItems,
    required this.hasDiscount,
    required this.isTaxable,
    required this.active,
    required this.titleController,
    required this.priceController,
    required this.typeController,
    required this.discountPriceController,
    required this.taxController,
    required this.onSaveToItems,
    required this.onHasDiscount,
    required this.onTaxable,
    required this.onContinue,
    required this.checkActive,
  });

  final bool select;
  final bool saveToItems;
  final bool hasDiscount;
  final bool isTaxable;
  final bool active;
  final TextEditingController titleController;
  final TextEditingController priceController;
  final TextEditingController typeController;
  final TextEditingController discountPriceController;
  final TextEditingController taxController;
  final VoidCallback onSaveToItems;
  final VoidCallback onHasDiscount;
  final VoidCallback onTaxable;
  final VoidCallback onContinue;
  final void Function(String) checkActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ItemField(
                controller: titleController,
                hintText: 'Title',
                onChanged: checkActive,
              ),
              if (select) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: TitleText(title: 'Save to Items catalog'),
                    ),
                    SwitchButton(
                      isActive: saveToItems,
                      onPressed: onSaveToItems,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                height: 22,
                child: const Row(
                  children: [
                    TitleText(title: 'Unit  Price'),
                    Spacer(),
                    TitleText(title: 'Unit Type'),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ItemField(
                        controller: priceController,
                        hintText: 'Price',
                        keyboardType: TextInputType.number,
                        onChanged: checkActive,
                      ),
                    ),
                    const DividerWidget(),
                    Expanded(
                      child: ItemField(
                        controller: typeController,
                        hintText: 'Optional',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Expanded(
                    child: TitleText(title: 'Discount'),
                  ),
                  SwitchButton(
                    isActive: hasDiscount,
                    onPressed: onHasDiscount,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (hasDiscount)
                ItemField(
                  controller: discountPriceController,
                  hintText: 'Discount Price',
                  keyboardType: TextInputType.number,
                  onChanged: checkActive,
                ),
              const SizedBox(height: 26),
              Row(
                children: [
                  const Expanded(
                    child: TitleText(title: 'Taxable?'),
                  ),
                  SwitchButton(
                    isActive: isTaxable,
                    onPressed: onTaxable,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (isTaxable)
                ItemField(
                  controller: taxController,
                  hintText: 'Tax %',
                  keyboardType: TextInputType.number,
                  onChanged: checkActive,
                ),
            ],
          ),
        ),
        MainButtonWrapper(
          children: [
            MainButton(
              title: 'Continue',
              active: active,
              onPressed: onContinue,
            ),
          ],
        ),
      ],
    );
  }
}
