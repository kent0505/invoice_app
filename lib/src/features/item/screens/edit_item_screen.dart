import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/divider_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/widgets/switch_button.dart';
import '../../../core/widgets/title_text.dart';
import '../bloc/item_bloc.dart';
import '../models/item.dart';
import '../widgets/item_field.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({super.key, required this.item});

  final Item item;

  static const routePath = '/EditItemScreen';

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final titleController = TextEditingController();
  final typeController = TextEditingController();
  final priceController = TextEditingController();
  final discountPriceController = TextEditingController();
  final taxController = TextEditingController();

  bool active = true;
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

  void onDelete() {
    DialogWidget.show(
      context,
      title: 'Delete?',
      delete: true,
      onPressed: () {
        context.read<ItemBloc>().add(DeleteItem(item: widget.item));
        context.pop();
        context.pop();
      },
    );
  }

  void onEdit() {
    final item = widget.item;
    item.title = titleController.text;
    item.type = typeController.text;
    item.price = priceController.text;
    item.discountPrice = discountPriceController.text;
    item.tax = taxController.text;
    context.read<ItemBloc>().add(EditItem(item: item));
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.item.title;
    typeController.text = widget.item.type;
    priceController.text = widget.item.price;
    discountPriceController.text = widget.item.discountPrice;
    taxController.text = widget.item.tax;
    hasDiscount = widget.item.discountPrice.isNotEmpty;
    isTaxable = widget.item.tax.isNotEmpty;
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
      appBar: Appbar(
        title: 'Edit Item',
        right: Button(
          onPressed: onDelete,
          child: const SvgWidget(Assets.delete),
        ),
      ),
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
                title: 'Edit',
                active: active,
                onPressed: onEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
