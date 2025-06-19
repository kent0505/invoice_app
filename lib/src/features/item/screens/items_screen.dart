import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/no_data.dart';
import '../../../core/widgets/search_field.dart';
import '../bloc/item_bloc.dart';
import '../models/item.dart';
import '../widgets/item_tile.dart';
import 'create_item_screen.dart';
import 'edit_item_screen.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key, required this.select});

  final bool select;

  static const routePath = '/ItemsScreen';

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final searchController = TextEditingController();

  void onSearch(String _) {
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Appbar(
        title: 'Items',
        right: Button(
          onPressed: () {
            context
                .push<Item?>(CreateItemScreen.routePath, extra: widget.select)
                .then(
              (value) {
                if (widget.select && context.mounted) context.pop(value);
              },
            );
          },
          child: const Text(
            '+',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: AppFonts.w400,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchField(
              controller: searchController,
              onChanged: onSearch,
            ),
          ),
          Expanded(
            child: BlocBuilder<ItemBloc, ItemState>(
              builder: (context, state) {
                if (state is ItemsLoaded) {
                  final items = state.items
                      .where((element) => element.invoiceID == 0)
                      .toList();

                  final sorted = searchController.text.isEmpty
                      ? items
                      : items.where((client) {
                          return client.title
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase());
                        }).toList();

                  return sorted.isEmpty
                      ? const NoData()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];

                            return ItemTile(
                              item: item,
                              onPressed: () {
                                widget.select
                                    ? context.pop(item)
                                    : context.push(
                                        EditItemScreen.routePath,
                                        extra: item,
                                      );
                              },
                            );
                          },
                        );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
