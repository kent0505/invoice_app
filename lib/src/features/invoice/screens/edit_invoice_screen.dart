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
import '../../business/bloc/business_bloc.dart';
import '../../business/models/business.dart';
import '../../business/screens/business_screen.dart';
import '../../business/screens/signature_screen.dart';
import '../../client/bloc/client_bloc.dart';
import '../../client/models/client.dart';
import '../../client/screens/clients_screen.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../../item/screens/items_screen.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../widgets/invoice_appbar.dart';
import '../widgets/invoice_dates.dart';
import '../widgets/invoice_select_data.dart';
import '../widgets/invoice_selected_data.dart';

class EditInvoiceScreen extends StatefulWidget {
  const EditInvoiceScreen({super.key, required this.invoice});

  final Invoice invoice;

  static const routePath = '/EditInvoiceScreen';

  @override
  State<EditInvoiceScreen> createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  int date = 0;
  int dueDate = 0;
  List<Business> business = [];
  List<Client> clients = [];
  List<Item> items = [];
  bool active = true;
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
            invoiceID: widget.invoice.id,
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

  void onEdit() {
    context.read<InvoiceBloc>().add(
          EditInvoice(
            invoice: Invoice(
              id: widget.invoice.id,
              number: widget.invoice.number,
              date: date,
              dueDate: dueDate,
              businessID: business.first.id,
              clientID: clients.first.id,
              paymentDate: widget.invoice.paymentDate,
              paymentMethod: widget.invoice.paymentMethod,
              imageSignature: signature ?? '',
            ),
          ),
        );
    context.read<ItemBloc>().add(AddItem(items: items));
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    date = widget.invoice.date;
    dueDate = widget.invoice.dueDate;
    signature = widget.invoice.imageSignature;
    hasSignature = widget.invoice.imageSignature.isNotEmpty;
    try {
      final b = context.read<BusinessBloc>().state.firstWhere((element) {
        return element.id == widget.invoice.businessID;
      });
      business.add(b);
    } catch (e) {
      logger(e);
    }
    try {
      final c = context.read<ClientBloc>().state.firstWhere((element) {
        return element.id == widget.invoice.clientID;
      });
      clients.add(c);
    } catch (e) {
      logger(e);
    }
    items = context.read<ItemBloc>().state.where((element) {
      return element.invoiceID == widget.invoice.id;
    }).toList();
    checkActive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InvoiceAppbar(
        title: 'Edit invoice',
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
                  number: widget.invoice.number,
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
                title: 'Edit Invoice',
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
