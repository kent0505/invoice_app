import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/date_pick.dart';
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
import '../models/photo.dart';
import '../models/preview_data.dart';
import '../widgets/invoice_appbar.dart';
import '../widgets/invoice_body.dart';
import 'invoice_preview_screen.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key, required this.isEstimate});

  final String isEstimate;

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
  List<Photo> photos = [];
  bool active = false;
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
          });
        }
      },
    );
  }

  void onPreview() {
    context.push(
      InvoicePreviewScreen.routePath,
      extra: PreviewData(
        invoice: Invoice(
          id: id,
          number: number,
          template: 1,
          date: date,
          dueDate: dueDate,
          businessID: 0,
          clientID: 0,
          imageSignature: hasSignature ? signature : '',
          isEstimate: widget.isEstimate,
        ),
        business: business,
        clients: clients,
        items: items,
        photos: photos,
        customize: false,
      ),
    );
  }

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

  void removeItem(Item item) {
    items.remove(item);
    checkActive();
  }

  void onAddPhotos() async {
    final images = await pickImages();
    if (images.isNotEmpty) {
      photos = [];
      for (final image in images.take(6)) {
        photos.add(Photo(
          id: id,
          path: image.path,
        ));
      }
      setState(() {});
    }
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
                imageSignature: signature,
                isEstimate: widget.isEstimate,
              ),
              photos: photos,
            ),
          );
      context.read<ItemBloc>().add(AddItems(id: id, items: items));
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
    final state = context.read<InvoiceBloc>().state;
    if (state is InvoiceLoaded) {
      number = state.invoices.length + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InvoiceAppbar(
        title: widget.isEstimate.isEmpty ? 'New invoice' : 'New estimate',
        onPreview: onPreview,
      ),
      body: InvoiceBody(
        date: date,
        dueDate: dueDate,
        number: number,
        business: business,
        clients: clients,
        items: items,
        photos: photos,
        isEstimate: widget.isEstimate,
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
        onCreate: onCreate,
        onAddPhotos: onAddPhotos,
        onRemoveItem: removeItem,
      ),
    );
  }
}
