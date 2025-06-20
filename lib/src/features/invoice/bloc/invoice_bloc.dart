import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/invoice_repository.dart';
import '../models/invoice.dart';

part 'invoice_event.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, List<Invoice>> {
  final InvoiceRepository _repository;

  InvoiceBloc({required InvoiceRepository repository})
      : _repository = repository,
        super([]) {
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
    Emitter<List<Invoice>> emit,
  ) async {
    final invoices = await _repository.getInvoices();
    emit(invoices);
  }

  void _addInvoice(
    AddInvoice event,
    Emitter<List<Invoice>> emit,
  ) async {
    await _repository.addInvoice(event.invoice);
    add(GetInvoices());
  }

  void _editInvoice(
    EditInvoice event,
    Emitter<List<Invoice>> emit,
  ) async {
    await _repository.editInvoice(event.invoice);
    add(GetInvoices());
  }

  void _deleteInvoice(
    DeleteInvoice event,
    Emitter<List<Invoice>> emit,
  ) async {
    await _repository.deleteInvoice(event.invoice);
    add(GetInvoices());
  }
}
