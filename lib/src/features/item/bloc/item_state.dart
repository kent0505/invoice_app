part of 'item_bloc.dart';

@immutable
sealed class ItemState {}

final class ItemInitial extends ItemState {}

final class ItemsLoaded extends ItemState {
  ItemsLoaded({required this.items});

  final List<Item> items;
}
