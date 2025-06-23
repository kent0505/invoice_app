import 'package:sqflite/sqflite.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../models/invoice.dart';
import '../models/photo.dart';

abstract interface class InvoiceRepository {
  const InvoiceRepository();

  Future<List<Invoice>> getInvoices();
  Future<List<Photo>> getPhotos();
  Future<void> addInvoice(Invoice invoice);
  Future<void> addPhotos(List<Photo> photos);
  Future<void> deletePhotos(Invoice invoice);
  Future<void> editInvoice(Invoice invoice);
  Future<void> deleteInvoice(Invoice invoice);
  Future<void> deleteItems(Invoice invoice);
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
  Future<List<Photo>> getPhotos() async {
    try {
      final maps = await _db.query(Tables.photos);
      return maps.map((map) => Photo.fromMap(map)).toList();
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
  Future<void> editInvoice(
    Invoice invoice, {
    List<Photo> photos = const [],
  }) async {
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
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> addPhotos(List<Photo> photos) async {
    try {
      for (final photo in photos) {
        await _db.insert(
          Tables.photos,
          photo.toMap(),
        );
      }
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> deletePhotos(Invoice invoice) async {
    try {
      await _db.delete(
        Tables.photos,
        where: 'id = ?',
        whereArgs: [invoice.id],
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> deleteItems(Invoice invoice) async {
    await _db.delete(
      Tables.items,
      where: 'invoiceID = ?',
      whereArgs: [invoice.id],
    );
  }
}
