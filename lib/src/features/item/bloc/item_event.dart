part of 'item_bloc.dart';

@immutable
sealed class ItemEvent {}

final class GetItems extends ItemEvent {}

final class AddItem extends ItemEvent {
  AddItem({
    this.item,
    this.items = const [],
  });

  final Item? item;
  final List<Item> items;
}

final class EditItem extends ItemEvent {
  EditItem({required this.item});

  final Item item;
}

final class DeleteItem extends ItemEvent {
  DeleteItem({required this.item});

  final Item item;
}
