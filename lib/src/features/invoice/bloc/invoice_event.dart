part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceEvent {}

final class GetInvoices extends InvoiceEvent {}

final class AddInvoice extends InvoiceEvent {
  AddInvoice({required this.invoice});

  final Invoice invoice;
}

final class EditInvoice extends InvoiceEvent {
  EditInvoice({required this.invoice});

  final Invoice invoice;
}

final class DeleteInvoice extends InvoiceEvent {
  DeleteInvoice({required this.invoice});

  final Invoice invoice;
}
