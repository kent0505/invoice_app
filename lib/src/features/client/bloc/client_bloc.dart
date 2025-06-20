import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/client_repository.dart';
import '../models/client.dart';

part 'client_event.dart';

class ClientBloc extends Bloc<ClientEvent, List<Client>> {
  final ClientRepository _repository;

  ClientBloc({required ClientRepository repository})
      : _repository = repository,
        super([]) {
    on<ClientEvent>(
      (event, emit) => switch (event) {
        GetClients() => _getClients(event, emit),
        AddClient() => _addClient(event, emit),
        EditClient() => _editClient(event, emit),
        DeleteClient() => _deleteClient(event, emit),
      },
    );
  }

  void _getClients(
    GetClients event,
    Emitter<List<Client>> emit,
  ) async {
    final clients = await _repository.getClients();
    emit(clients);
  }

  void _addClient(
    AddClient event,
    Emitter<List<Client>> emit,
  ) async {
    await _repository.addClient(event.client);
    add(GetClients());
  }

  void _editClient(
    EditClient event,
    Emitter<List<Client>> emit,
  ) async {
    await _repository.editClient(event.client);
    add(GetClients());
  }

  void _deleteClient(
    DeleteClient event,
    Emitter<List<Client>> emit,
  ) async {
    await _repository.deleteClient(event.client);
    add(GetClients());
  }
}
