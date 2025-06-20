import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/add_button.dart';
import '../../../core/widgets/appbar.dart';
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
        right: AddButton(
          onPressed: () async {
            Item? item = await context.push<Item?>(
              CreateItemScreen.routePath,
              extra: widget.select,
            );
            if (widget.select && context.mounted) context.pop(item);
          },
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
            child: BlocBuilder<ItemBloc, List<Item>>(
              builder: (context, items) {
                items = items.where((element) {
                  return element.invoiceID == 0;
                }).toList();

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
              },
            ),
          ),
        ],
      ),
    );
  }
}
