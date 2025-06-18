import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/invoice_repository.dart';
import '../models/invoice.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceRepository _repository;

  InvoiceBloc({required InvoiceRepository repository})
      : _repository = repository,
        super(InvoiceInitial()) {
    on<InvoiceEvent>(
      (event, emit) => switch (event) {
        GetInvoices() => _getInvoices(event, emit),
        AddInvoice() => _addInvoice(event, emit),
        EditInvoice() => _editInvoice(event, emit),
        DeleteInvoice() => _deleteInvoice(event, emit),
      },
    );
  }

  void _getInvoices(
    GetInvoices event,
    Emitter<InvoiceState> emit,
  ) async {
    final invoices = await _repository.getInvoices();
    emit(InvoicesLoaded(invoices: invoices));
  }

  void _addInvoice(
    AddInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    await _repository.addInvoice(event.invoice);
    add(GetInvoices());
  }

  void _editInvoice(
    EditInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    await _repository.editInvoice(event.invoice);
    add(GetInvoices());
  }

  void _deleteInvoice(
    DeleteInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    await _repository.deleteInvoice(event.invoice);
    add(GetInvoices());
  }
}
