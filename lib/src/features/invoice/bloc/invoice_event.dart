part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceEvent {}

final class GetInvoices extends InvoiceEvent {}

final class AddInvoice extends InvoiceEvent {
  AddInvoice({
    required this.invoice,
    this.photos = const [],
  });

  final Invoice invoice;
  final List<Photo> photos;
}

final class EditInvoice extends InvoiceEvent {
  EditInvoice({
    required this.invoice,
    this.photos = const [],
  });

  final Invoice invoice;
  final List<Photo> photos;
}

final class DeleteInvoice extends InvoiceEvent {
  DeleteInvoice({required this.invoice});

  final Invoice invoice;
}
