import 'package:sqflite/sqflite.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../models/invoice.dart';

abstract interface class InvoiceRepository {
  const InvoiceRepository();

  Future<List<Invoice>> getInvoices();
  Future<void> addInvoice(Invoice invoice);
  Future<void> editInvoice(Invoice invoice);
  Future<void> deleteInvoice(Invoice invoice);
}

final class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl({required Database db}) : _db = db;

  final Database _db;

  @override
  Future<List<Invoice>> getInvoices() async {
    try {
      final maps = await _db.query(Tables.invoices);
      return maps.map((map) => Invoice.fromMap(map)).toList();
    } catch (e) {
      logger(e);
      return [];
    }
  }

  @override
  Future<void> addInvoice(Invoice invoice) async {
    try {
      await _db.insert(
        Tables.invoices,
        invoice.toMap(),
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> editInvoice(Invoice invoice) async {
    try {
      await _db.update(
        Tables.invoices,
        invoice.toMap(),
        where: 'id = ?',
        whereArgs: [invoice.id],
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> deleteInvoice(Invoice invoice) async {
    try {
      await _db.delete(
        Tables.invoices,
        where: 'id = ?',
        whereArgs: [invoice.id],
      );
      await _db.delete(
        Tables.items,
        where: 'invoiceID = ?',
        whereArgs: [invoice.id],
      );
    } catch (e) {
      logger(e);
    }
  }
}
