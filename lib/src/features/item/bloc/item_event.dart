part of 'item_bloc.dart';

@immutable
sealed class ItemEvent {}

final class GetItems extends ItemEvent {}

final class AddItem extends ItemEvent {
  AddItem({required this.item});

  final Item item;
}

final class AddItems extends ItemEvent {
  AddItems({
    required this.id,
    required this.items,
  });

  final int id;
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
