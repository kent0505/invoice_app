part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceState {}

final class InvoiceInitial extends InvoiceState {}

final class InvoiceLoaded extends InvoiceState {
  InvoiceLoaded({
    required this.invoices,
    required this.photos,
  });

  final List<Invoice> invoices;
  final List<Photo> photos;
}
