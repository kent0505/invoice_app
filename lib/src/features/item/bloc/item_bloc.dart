import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/item_repository.dart';
import '../models/item.dart';

part 'item_event.dart';

class ItemBloc extends Bloc<ItemEvent, List<Item>> {
  final ItemRepository _repository;

  ItemBloc({required ItemRepository repository})
      : _repository = repository,
        super([]) {
    on<ItemEvent>(
      (event, emit) => switch (event) {
        GetItems() => _getItems(event, emit),
        AddItem() => _addItem(event, emit),
        AddItems() => _addItems(event, emit),
        EditItem() => _editItem(event, emit),
        DeleteItem() => _deleteItem(event, emit),
      },
    );
  }

  void _getItems(
    GetItems event,
    Emitter<List<Item>> emit,
  ) async {
    final items = await _repository.getItems();
    emit(items);
  }

  void _addItem(
    AddItem event,
    Emitter<List<Item>> emit,
  ) async {
    await _repository.addItem(event.item);
    add(GetItems());
  }

  void _addItems(
    AddItems event,
    Emitter<List<Item>> emit,
  ) async {
    await _repository.deleteItems(event.id);
    await _repository.addItems(event.items);
    add(GetItems());
  }

  void _editItem(
    EditItem event,
    Emitter<List<Item>> emit,
  ) async {
    await _repository.editItem(event.item);
    add(GetItems());
  }

  void _deleteItem(
    DeleteItem event,
    Emitter<List<Item>> emit,
  ) async {
    await _repository.deleteItem(event.item);
    add(GetItems());
  }
}
