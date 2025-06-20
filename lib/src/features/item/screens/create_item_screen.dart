import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/divider_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/switch_button.dart';
import '../../../core/widgets/title_text.dart';
import '../bloc/item_bloc.dart';
import '../models/item.dart';
import '../widgets/item_field.dart';

class CreateItemScreen extends StatefulWidget {
  const CreateItemScreen({super.key, required this.select});

  final bool select;

  static const routePath = '/CreateItemScreen';

  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  final titleController = TextEditingController();
  final typeController = TextEditingController();
  final priceController = TextEditingController();
  final discountPriceController = TextEditingController();
  final taxController = TextEditingController();

  bool active = false;
  bool saveToItems = false;
  bool hasDiscount = false;
  bool isTaxable = false;

  void checkActive(String _) {
    setState(() {
      active = [
        titleController,
        priceController,
        if (hasDiscount) discountPriceController,
        if (isTaxable) taxController,
      ].every((element) => element.text.isNotEmpty);
    });
  }

  void onSaveToItems() {
    setState(() {
      saveToItems = !saveToItems;
    });
  }

  void onHasDiscount() {
    if (hasDiscount) {
      discountPriceController.clear();
      hasDiscount = false;
    } else {
      hasDiscount = true;
    }
    checkActive('');
  }

  void onTaxable() {
    if (isTaxable) {
      taxController.clear();
      isTaxable = false;
    } else {
      isTaxable = true;
    }
    checkActive('');
  }

  void save(Item item) {
    context.read<ItemBloc>().add(AddItem(item: item));
  }

  void onContinue() {
    final item = Item(
      id: getTimestamp(),
      title: titleController.text,
      type: typeController.text,
      price: priceController.text,
      discountPrice: discountPriceController.text.isEmpty
          ? priceController.text
          : discountPriceController.text,
      tax: taxController.text,
    );

    if (widget.select) {
      if (saveToItems) save(item);
      context.pop(item);
    } else {
      save(item);
      context.pop();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    typeController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    taxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const Appbar(title: 'New Item'),
      body: Column(
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
                if (widget.select) ...[
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
      ),
    );
  }
}
