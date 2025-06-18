import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/client_repository.dart';
import '../models/client.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientRepository _repository;

  ClientBloc({required ClientRepository repository})
      : _repository = repository,
        super(ClientInitial()) {
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
    Emitter<ClientState> emit,
  ) async {
    final clients = await _repository.getClients();
    emit(ClientsLoaded(clients: clients));
  }

  void _addClient(
    AddClient event,
    Emitter<ClientState> emit,
  ) async {
    await _repository.addClient(event.client);
    add(GetClients());
  }

  void _editClient(
    EditClient event,
    Emitter<ClientState> emit,
  ) async {
    await _repository.editClient(event.client);
    add(GetClients());
  }

  void _deleteClient(
    DeleteClient event,
    Emitter<ClientState> emit,
  ) async {
    await _repository.deleteClient(event.client);
    add(GetClients());
  }
}
