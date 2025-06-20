import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

import '../../../core/widgets/main_button.dart';
// import '../../../core/constants.dart';
// import '../../../core/widgets/title_text.dart';
// import '../../business/models/business.dart';
// import '../../business/screens/business_screen.dart';
// import '../../client/models/client.dart';
// import '../../client/screens/clients_screen.dart';
// import '../../item/bloc/item_bloc.dart';
// import '../../item/models/item.dart';
// import '../../item/screens/items_screen.dart';
// import '../bloc/invoice_bloc.dart';
// import '../widgets/invoice_appbar.dart';
import '../models/invoice.dart';

class EditInvoiceScreen extends StatefulWidget {
  const EditInvoiceScreen({super.key, required this.invoice});

  final Invoice invoice;

  static const routePath = '/EditInvoiceScreen';

  @override
  State<EditInvoiceScreen> createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  // int id = 0;
  // int number = 0;
  // int date = 0;
  // int dueDate = 0;
  // Business? business;
  // Client? client;
  // List<Item> items = [];
  // double totalPrice = 0;
  // bool active = false;

  // void checkActive() {
  //   setState(() {
  //     active = business != null && client != null && items.isNotEmpty;
  //     totalPrice = 0;
  //     for (Item item in items) {
  //       totalPrice += double.tryParse(item.discountPrice) ?? 0;
  //     }
  //   });
  // }

  // void onPreview() {}

  // void onDone() {}

  // void onDate() {}

  // void onDueDate() {}

  // void onSelectBusiness() {
  //   if (business == null) {
  //     context.push<Business?>(BusinessScreen.routePath, extra: true).then(
  //       (value) {
  //         if (value != null) {
  //           business = value;
  //           checkActive();
  //         }
  //       },
  //     );
  //   } else {
  //     business = null;
  //     checkActive();
  //   }
  // }

  // void onSelectClient() {
  //   if (client == null) {
  //     context.push<Client?>(ClientsScreen.routePath, extra: true).then(
  //       (value) {
  //         if (value != null) {
  //           client = value;
  //           checkActive();
  //         }
  //       },
  //     );
  //   } else {
  //     client = null;
  //     checkActive();
  //   }
  // }

  // void onSelectItems() {
  //   context.push<Item?>(ItemsScreen.routePath, extra: true).then(
  //     (value) {
  //       if (value != null) {
  //         items.add(
  //           Item(
  //             id: id,
  //             title: value.title,
  //             type: value.type,
  //             price: value.price,
  //             discountPrice: value.discountPrice,
  //             tax: value.tax,
  //             invoiceID: id,
  //           ),
  //         );
  //         checkActive();
  //       }
  //     },
  //   );
  // }

  // void removeItem(int index) {
  //   items.removeAt(index);
  //   checkActive();
  // }

  // void onCreate() {
  //   context.read<InvoiceBloc>().add(
  //         AddInvoice(
  //           invoice: Invoice(
  //             id: id,
  //             number: number,
  //             date: date,
  //             dueDate: dueDate,
  //             businessID: business!.id,
  //             clientID: client!.id,
  //           ),
  //         ),
  //       );
  //   context.read<ItemBloc>().add(AddItem(items: items));
  //   context.pop();
  // }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: InvoiceAppbar(
      //   title: 'New invoice',
      //   onPreview: onPreview,
      //   onDone: onDone,
      // ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // const Row(
                //   children: [
                //     SizedBox(
                //       width: 100,
                //       child: TitleText(title: 'Issued'),
                //     ),
                //     SizedBox(
                //       width: 100,
                //       child: TitleText(title: 'Due'),
                //     ),
                //     Spacer(),
                //     TitleText(title: '#'),
                //   ],
                // ),
                // const SizedBox(height: 6),
                // _Dates(
                //   date: date,
                //   dueDate: dueDate,
                //   number: number,
                //   onDate: onDate,
                //   onDueDate: onDueDate,
                // ),
                // const SizedBox(height: 16),
                // TitleText(title: 'Business account'),
                // const SizedBox(height: 6),
                // business == null
                //     ? _Select(
                //         title: 'Choose Account',
                //         onPressed: onSelectBusiness,
                //       )
                //     : _Selected(
                //         title: business!.name,
                //         onPressed: onSelectBusiness,
                //       ),
                // const SizedBox(height: 16),
                // TitleText(title: 'Client'),
                // const SizedBox(height: 6),
                // client == null
                //     ? _Select(
                //         title: 'Add Client',
                //         onPressed: onSelectClient,
                //       )
                //     : _Selected(
                //         title: client!.name,
                //         onPressed: onSelectClient,
                //       ),
                // const SizedBox(height: 16),
                // TitleText(title: 'Items'),
                // const SizedBox(height: 6),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(6),
                //   ),
                //   child: Column(
                //     children: List.generate(
                //       items.length,
                //       (index) {
                //         return _Selected(
                //           title: items[index].title,
                //           onPressed: () {
                //             removeItem(index);
                //           },
                //         );
                //       },
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 6),
                // _Select(
                //   title: items.isEmpty ? 'Add Item' : 'Add another Item',
                //   onPressed: onSelectItems,
                // ),
                // const SizedBox(height: 16),
                // TitleText(title: 'Summary'),
                // const SizedBox(height: 6),
                // Container(
                //   height: 40,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(6),
                //   ),
                //   child: Row(
                //     children: [
                //       const SizedBox(width: 8),
                //       const Text(
                //         'Total',
                //         style: TextStyle(
                //           color: Colors.black,
                //           fontSize: 12,
                //           fontFamily: AppFonts.w600,
                //         ),
                //       ),
                //       const Spacer(),
                //       Text(
                //         '${totalPrice.toStringAsFixed(2).replaceAll('.', ',')} \$',
                //         style: const TextStyle(
                //           color: Colors.black,
                //           fontSize: 12,
                //           fontFamily: AppFonts.w600,
                //         ),
                //       ),
                //       const SizedBox(width: 8),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 16),
                // TitleText(title: 'Photos'),
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              // MainButton(
              //   title: 'Edit Invoice',
              //   active: active,
              //   onPressed: onCreate,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
