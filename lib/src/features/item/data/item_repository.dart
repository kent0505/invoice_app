import 'package:sqflite/sqflite.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../models/item.dart';

abstract interface class ItemRepository {
  const ItemRepository();

  Future<List<Item>> getInvoiceItems(int invoiceID);
  Future<List<Item>> getItems();
  Future<void> addItem(Item item);
  Future<void> addItems(List<Item> items);
  Future<void> editItem(Item item);
  Future<void> deleteItem(Item item);
  Future<void> deleteItems(int id);
}

final class ItemRepositoryImpl implements ItemRepository {
  ItemRepositoryImpl({required Database db}) : _db = db;

  final Database _db;

  @override
  Future<List<Item>> getInvoiceItems(int invoiceID) async {
    try {
      final maps = await _db.query(
        Tables.items,
        where: 'invoiceID = ?',
        whereArgs: [invoiceID],
      );
      return maps.map((map) => Item.fromMap(map)).toList();
    } catch (e) {
      logger(e);
      return [];
    }
  }

  @override
  Future<List<Item>> getItems() async {
    try {
      final maps = await _db.query(Tables.items);
      return maps.map((map) => Item.fromMap(map)).toList();
    } catch (e) {
      logger(e);
      return [];
    }
  }

  @override
  Future<void> addItem(Item item) async {
    try {
      await _db.insert(
        Tables.items,
        item.toMap(),
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> addItems(List<Item> items) async {
    try {
      for (final item in items) {
        await _db.insert(
          Tables.items,
          item.toMap(),
        );
      }
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> editItem(Item item) async {
    try {
      await _db.update(
        Tables.items,
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> deleteItem(Item item) async {
    try {
      await _db.delete(
        Tables.items,
        where: 'id = ?',
        whereArgs: [item.id],
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> deleteItems(int id) async {
    try {
      await _db.delete(
        Tables.items,
        where: 'invoiceID = ?',
        whereArgs: [id],
      );
    } catch (e) {
      logger(e);
    }
  }
}
