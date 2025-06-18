import 'package:sqflite/sqflite.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../models/client.dart';

abstract interface class ClientRepository {
  const ClientRepository();

  Future<List<Client>> getClients();
  Future<void> addClient(Client client);
  Future<void> editClient(Client client);
  Future<void> deleteClient(Client client);
}

final class ClientRepositoryImpl implements ClientRepository {
  ClientRepositoryImpl({required Database db}) : _db = db;

  final Database _db;

  @override
  Future<List<Client>> getClients() async {
    try {
      final maps = await _db.query(Tables.clients);
      return maps.map((map) => Client.fromMap(map)).toList();
    } catch (e) {
      logger(e);
      return [];
    }
  }

  @override
  Future<void> addClient(Client client) async {
    try {
      await _db.insert(
        Tables.clients,
        client.toMap(),
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> editClient(Client client) async {
    try {
      await _db.update(
        Tables.clients,
        client.toMap(),
        where: 'id = ?',
        whereArgs: [client.id],
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> deleteClient(Client client) async {
    try {
      await _db.delete(
        Tables.clients,
        where: 'id = ?',
        whereArgs: [client.id],
      );
    } catch (e) {
      logger(e);
    }
  }
}
