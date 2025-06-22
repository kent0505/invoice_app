import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils.dart';
import '../../../core/widgets/date_pick.dart';
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
import '../widgets/invoice_body.dart';

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
  String signature = '';

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
            logger(signature);
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
              imageSignature: signature,
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
      body: InvoiceBody(
        date: date,
        dueDate: dueDate,
        number: widget.invoice.number,
        business: business,
        clients: clients,
        items: items,
        signature: signature,
        hasSignature: hasSignature,
        active: active,
        onSelectBusiness: onSelectBusiness,
        onSelectClient: onSelectClient,
        onSelectItems: onSelectItems,
        onSignature: onSignature,
        onAddSignature: onAddSignature,
        onDate: onDate,
        onDueDate: onDueDate,
        onCreate: onEdit,
        onRemoveItem: removeItem,
      ),
    );
  }
}
