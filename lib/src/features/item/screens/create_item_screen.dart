import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../bloc/item_bloc.dart';
import '../models/item.dart';
import '../widgets/item_body.dart';

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
      body: ItemBody(
        select: widget.select,
        saveToItems: saveToItems,
        hasDiscount: hasDiscount,
        isTaxable: isTaxable,
        active: active,
        titleController: titleController,
        priceController: priceController,
        typeController: typeController,
        discountPriceController: discountPriceController,
        taxController: taxController,
        checkActive: checkActive,
        onSaveToItems: onSaveToItems,
        onHasDiscount: onHasDiscount,
        onTaxable: onTaxable,
        onContinue: onContinue,
      ),
    );
  }
}
