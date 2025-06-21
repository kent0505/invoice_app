import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/date_pick.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/switch_button.dart';
import '../../../core/widgets/title_text.dart';
import '../../business/models/business.dart';
import '../../business/screens/business_screen.dart';
import '../../business/screens/signature_screen.dart';
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
import '../widgets/invoice_dates.dart';
import '../widgets/invoice_select_data.dart';
import '../widgets/invoice_selected_data.dart';

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
  List<Business> business = [];
  List<Client> clients = [];
  List<Item> items = [];
  bool active = false;
  bool hasSignature = false;
  String? signature;

  void checkActive() {
    setState(() {
      active = business.isNotEmpty && clients.isNotEmpty && items.isNotEmpty;
    });
  }

  void onSignature() {
    hasSignature = !hasSignature;
    checkActive();
  }

  void onAddSignature() async {
    context.push<String?>(SignatureScreen.routePath).then(
      (value) {
        if (value != null) {
          setState(() {
            signature = value;
          });
        }
      },
    );
  }

  void onPreview() {}

  void onDate() {
    DatePick.show(
      context,
      DateTime.fromMillisecondsSinceEpoch(date),
    ).then((value) {
      setState(() {
        date = value.millisecondsSinceEpoch;
      });
    });
  }

  void onDueDate() {
    DatePick.show(
      context,
      DateTime.fromMillisecondsSinceEpoch(getTimestamp()),
    ).then((value) {
      setState(() {
        dueDate = value.millisecondsSinceEpoch;
      });
    });
  }

  void onSelectBusiness() {
    if (business.isEmpty) {
      context
          .push<Business?>(BusinessScreen.routePath, extra: true)
          .then((value) {
        if (value != null) {
          business.add(value);
          checkActive();
        }
      });
    } else {
      business.clear();
      checkActive();
    }
  }

  void onSelectClient() {
    if (clients.isEmpty) {
      context.push<Client?>(ClientsScreen.routePath, extra: true).then((value) {
        if (value != null) {
          clients.add(value);
          checkActive();
        }
      });
    } else {
      clients.clear();
      checkActive();
    }
  }

  void onSelectItems() async {
    context.push<Item?>(ItemsScreen.routePath, extra: true).then((value) {
      if (value != null) {
        items.add(
          Item(
            id: value.id,
            title: value.title,
            type: value.type,
            price: value.price,
            discountPrice: value.discountPrice,
            tax: value.tax,
            invoiceID: id,
          ),
        );
        checkActive();
      }
    });
  }

  void removeItem(int index) {
    items.removeAt(index);
    checkActive();
  }

  void onCreate() {
    final isPro = context.read<ProBloc>().state.isPro;
    final available = context.read<ProRepository>().getAvailable();
    if (isPro || available >= 1) {
      context.read<ProRepository>().saveAvailable(available - 1);
      context.read<InvoiceBloc>().add(
            AddInvoice(
              invoice: Invoice(
                id: id,
                number: number,
                date: date,
                dueDate: dueDate,
                businessID: business.first.id,
                clientID: clients.first.id,
                imageSignature: signature ?? '',
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
                      width: 120,
                      child: TitleText(title: 'Issued'),
                    ),
                    SizedBox(
                      width: 120,
                      child: TitleText(title: 'Due'),
                    ),
                    Spacer(),
                    TitleText(title: '#'),
                  ],
                ),
                const SizedBox(height: 6),
                InvoiceDates(
                  date: date,
                  dueDate: dueDate,
                  number: number,
                  onDate: onDate,
                  onDueDate: onDueDate,
                ),
                const SizedBox(height: 16),
                const TitleText(title: 'Business account'),
                const SizedBox(height: 6),
                business.isEmpty
                    ? InvoiceSelectData(
                        title: 'Choose Account',
                        onPressed: onSelectBusiness,
                      )
                    : InvoiceSelectedData(
                        title: business.first.name,
                        onPressed: onSelectBusiness,
                      ),
                const SizedBox(height: 16),
                const TitleText(title: 'Client'),
                const SizedBox(height: 6),
                clients.isEmpty
                    ? InvoiceSelectData(
                        title: 'Add Client',
                        onPressed: onSelectClient,
                      )
                    : InvoiceSelectedData(
                        title: clients.first.name,
                        onPressed: onSelectClient,
                      ),
                const SizedBox(height: 16),
                const TitleText(title: 'Items'),
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
                        return InvoiceSelectedData(
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
                InvoiceSelectData(
                  title: items.isEmpty ? 'Add Item' : 'Add another Item',
                  onPressed: onSelectItems,
                ),
                const SizedBox(height: 16),
                const TitleText(title: 'Summary'),
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: TitleText(title: 'Signature'),
                    ),
                    SwitchButton(
                      isActive: hasSignature,
                      onPressed: onSignature,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (hasSignature) ...[
                  SvgPicture.string(signature ?? ''),
                  const SizedBox(height: 16),
                  MainButton(
                    title: signature == null
                        ? 'Create a signature'
                        : 'Change signature',
                    outlined: true,
                    onPressed: onAddSignature,
                  ),
                ],

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
