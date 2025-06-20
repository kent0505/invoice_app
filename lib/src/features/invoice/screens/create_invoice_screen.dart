import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/divider_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/widgets/title_text.dart';
import '../../business/models/business.dart';
import '../../business/screens/business_screen.dart';
import '../../client/models/client.dart';
import '../../client/screens/clients_screen.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../../item/screens/items_screen.dart';
import '../../pro/bloc/pro_bloc.dart';
import '../../pro/data/pro_repository.dart';
import '../../pro/screens/pro_page.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../widgets/invoice_appbar.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  static const routePath = '/CreateInvoiceScreen';

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  int id = 0;
  int number = 0;
  int date = 0;
  int dueDate = 0;
  Business? business;
  Client? client;
  List<Item> items = [];
  // double totalPrice = 0;
  bool active = false;

  void checkActive() {
    setState(() {
      active = business != null && client != null && items.isNotEmpty;
      // calculateInvoiceMoney(items: items, invoiceID: invoiceID)
      // totalPrice = 0;
      // for (Item item in items) {
      //   final basePrice = double.tryParse(item.discountPrice) ?? 0;
      //   final taxRate = double.tryParse(item.tax) ?? 0;
      //   final priceWithTax = basePrice + (basePrice * taxRate / 100);
      //   totalPrice += priceWithTax;
      // }
    });
  }

  void onPreview() {}

  void onDate() {}

  void onDueDate() {}

  void onSelectBusiness() async {
    if (business == null) {
      business = await context.push<Business?>(
        BusinessScreen.routePath,
        extra: true,
      );
      if (business != null) checkActive();
    } else {
      business = null;
      checkActive();
    }
  }

  void onSelectClient() async {
    if (client == null) {
      client = await context.push<Client?>(
        ClientsScreen.routePath,
        extra: true,
      );
      if (client != null) checkActive();
    } else {
      client = null;
      checkActive();
    }
  }

  void onSelectItems() async {
    Item? item = await context.push<Item?>(
      ItemsScreen.routePath,
      extra: true,
    );
    if (item != null) {
      items.add(
        Item(
          id: id,
          title: item.title,
          type: item.type,
          price: item.price,
          discountPrice: item.discountPrice,
          tax: item.tax,
          invoiceID: id,
        ),
      );
      checkActive();
    }
  }

  void removeItem(int index) {
    items.removeAt(index);
    checkActive();
  }

  void onCreate() {
    final available = context.read<ProRepository>().getAvailable();
    if (available >= 1 || context.read<ProBloc>().state.isPro) {
      context.read<ProRepository>().saveAvailable(available - 1);
      context.read<InvoiceBloc>().add(
            AddInvoice(
              invoice: Invoice(
                id: id,
                number: number,
                date: date,
                dueDate: dueDate,
                businessID: business!.id,
                clientID: client!.id,
              ),
            ),
          );
      context.read<ItemBloc>().add(AddItem(items: items));
      context.pop();
    } else {
      context.push(
        ProScreen.routePath,
        extra: Identifiers.paywall1,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    id = getTimestamp();
    date = id;
    number = context.read<InvoiceBloc>().state.length + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InvoiceAppbar(
        title: 'New invoice',
        onPreview: onPreview,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: TitleText(title: 'Issued'),
                    ),
                    SizedBox(
                      width: 100,
                      child: TitleText(title: 'Due'),
                    ),
                    Spacer(),
                    TitleText(title: '#'),
                  ],
                ),
                const SizedBox(height: 6),
                _Dates(
                  date: date,
                  dueDate: dueDate,
                  number: number,
                  onDate: onDate,
                  onDueDate: onDueDate,
                ),
                const SizedBox(height: 16),
                TitleText(title: 'Business account'),
                const SizedBox(height: 6),
                business == null
                    ? _Select(
                        title: 'Choose Account',
                        onPressed: onSelectBusiness,
                      )
                    : _Selected(
                        title: business!.name,
                        onPressed: onSelectBusiness,
                      ),
                const SizedBox(height: 16),
                TitleText(title: 'Client'),
                const SizedBox(height: 6),
                client == null
                    ? _Select(
                        title: 'Add Client',
                        onPressed: onSelectClient,
                      )
                    : _Selected(
                        title: client!.name,
                        onPressed: onSelectClient,
                      ),
                const SizedBox(height: 16),
                TitleText(title: 'Items'),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: List.generate(
                      items.length,
                      (index) {
                        return _Selected(
                          title: items[index].title,
                          onPressed: () {
                            removeItem(index);
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                _Select(
                  title: items.isEmpty ? 'Add Item' : 'Add another Item',
                  onPressed: onSelectItems,
                ),
                const SizedBox(height: 16),
                TitleText(title: 'Summary'),
                const SizedBox(height: 6),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: AppFonts.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        // '${totalPrice.toStringAsFixed(2).replaceAll('.', ',')} \$',
                        calculateInvoiceMoney(items: items),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: AppFonts.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                // const SizedBox(height: 16),
                // TitleText(title: 'Photos'),
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              MainButton(
                title: 'Create New Invoice',
                active: active,
                onPressed: onCreate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dates extends StatelessWidget {
  const _Dates({
    required this.date,
    required this.dueDate,
    required this.number,
    required this.onDate,
    required this.onDueDate,
  });

  final int date;
  final int dueDate;
  final int number;
  final VoidCallback onDate;
  final VoidCallback onDueDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          _Issued(
            date: date,
            onPressed: onDate,
          ),
          const DividerWidget(),
          _Issued(
            date: dueDate,
            onPressed: onDueDate,
          ),
          const DividerWidget(),
          Expanded(
            child: Text(
              formatInvoiceNumber(number),
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: AppFonts.w400,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _Issued extends StatelessWidget {
  const _Issued({
    required this.date,
    required this.onPressed,
  });

  final int date;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: SizedBox(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            date == 0 ? '-' : formatTimestamp(date),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: AppFonts.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _Select extends StatelessWidget {
  const _Select({
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Button(
        onPressed: onPressed,
        minSize: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SvgWidget(Assets.add),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: AppFonts.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Selected extends StatelessWidget {
  const _Selected({
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: AppFonts.w600,
              ),
            ),
          ),
          Button(
            onPressed: onPressed,
            minSize: 40,
            child: const Icon(
              Icons.close_rounded,
              color: Color(0xffFF4400),
            ),
          ),
        ],
      ),
    );
  }
}
