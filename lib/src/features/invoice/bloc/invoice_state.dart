part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceState {}

final class InvoiceInitial extends InvoiceState {}

final class InvoicesLoaded extends InvoiceState {
  InvoicesLoaded({required this.invoices});

  final List<Invoice> invoices;
}
