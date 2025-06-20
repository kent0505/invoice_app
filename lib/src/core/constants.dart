abstract final class AppFonts {
  static const w400 = 'w400';
  static const w500 = 'w500';
  static const w600 = 'w600';
  static const w700 = 'w700';
  static const w800 = 'w800';
}

abstract final class Assets {
  static const addImage = 'assets/add_image.svg';
  static const add = 'assets/add.svg';
  static const back = 'assets/back.svg';
  static const calendar = 'assets/calendar.svg';
  static const delete = 'assets/delete.svg';
  static const edit = 'assets/edit.svg';
  static const icon = 'assets/icon.png';
  static const menu = 'assets/menu.svg';
  static const onboard1 = 'assets/onboard1.png';
  static const onboard2 = 'assets/onboard2.png';
  static const onboard3 = 'assets/onboard3.png';
  static const onboard4 = 'assets/onboard4.png';
  static const onboard5 = 'assets/onboard5.png';
  static const onboard6 = 'assets/onboard6.png';
  static const onboard7 = 'assets/onboard7.png';
  static const onboard8 = 'assets/onboard8.png';
  static const onboard9 = 'assets/onboard9.png';
  static const onboard10 = 'assets/onboard10.png';
  static const paid1 = 'assets/paid1.svg';
  static const paid2 = 'assets/paid2.svg';
  static const paid3 = 'assets/paid3.svg';
  static const paid4 = 'assets/paid4.svg';
  static const print = 'assets/print.svg';
  static const right = 'assets/right.svg';
  static const settings = 'assets/settings.svg';
  static const share = 'assets/share.svg';
  static const star = 'assets/star.svg';
  static const user = 'assets/user.svg';
}

abstract final class Keys {
  static const onboard = 'onboard';
  static const showCount = 'showCount';
  static const available = 'available';
}

abstract final class Identifiers {
  static const paywall1 = 'paywall_1';
  static const paywall2 = 'paywall_2';
}

abstract final class Tables {
  static const invoices = 'invoices';
  static const business = 'business';
  static const clients = 'clients';
  static const items = 'items';
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../data/category_repository.dart';
// import '../../../core/models/cat.dart';

// part 'category_event.dart';
// part 'category_state.dart';

// class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
//   final CategoryRepository _repository;

//   List<Cat> categories = [];

//   CategoryBloc({required CategoryRepository repository})
//       : _repository = repository,
//         super(CategoryInitial()) {
//     on<CategoryEvent>(
//       (event, emit) => switch (event) {
//         GetCategories() => _getCategories(event, emit),
//         AddCategory() => _addCategory(event, emit),
//         EditCategory() => _editCategory(event, emit),
//         DeleteCategory() => _deleteCategory(event, emit),
//       },
//     );
//   }

//   void _getCategories(
//     GetCategories event,
//     Emitter<CategoryState> emit,
//   ) async {
//     categories = await _repository.getCategories() + defaultCats;
//     emit(CategoriesLoaded(categories: categories));
//   }

//   void _addCategory(
//     AddCategory event,
//     Emitter<CategoryState> emit,
//   ) async {
//     await _repository.addCategory(event.cat);
//     add(GetCategories());
//   }

//   void _editCategory(
//     EditCategory event,
//     Emitter<CategoryState> emit,
//   ) async {
//     await _repository.editCategory(event.cat);
//     add(GetCategories());
//   }

//   void _deleteCategory(
//     DeleteCategory event,
//     Emitter<CategoryState> emit,
//   ) async {
//     await _repository.deleteCategory(event.cat);
//     add(GetCategories());
//   }
// }


// import 'package:sqflite/sqflite.dart';

// import '../../../core/config/constants.dart';
// import '../../../core/models/cat.dart';

// abstract interface class CategoryRepository {
//   const CategoryRepository();

//   Future<List<Cat>> getCategories();
//   Future<void> addCategory(Cat cat);
//   Future<void> editCategory(Cat cat);
//   Future<void> deleteCategory(Cat cat);
// }

// final class CategoryRepositoryImpl implements CategoryRepository {
//   CategoryRepositoryImpl({required Database db}) : _db = db;

//   final Database _db;

//   @override
//   Future<List<Cat>> getCategories() async {
//     final maps = await _db.query(Tables.categories);
//     return maps.map((map) => Cat.fromMap(map)).toList();
//   }

//   @override
//   Future<void> addCategory(Cat cat) async {
//     await _db.insert(
//       Tables.categories,
//       cat.toMap(),
//     );
//   }

//   @override
//   Future<void> editCategory(Cat cat) async {
//     await _db.update(
//       Tables.categories,
//       cat.toMap(),
//       where: 'id = ?',
//       whereArgs: [cat.id],
//     );
//   }

//   @override
//   Future<void> deleteCategory(Cat cat) async {
//     await _db.delete(
//       Tables.categories,
//       where: 'id = ?',
//       whereArgs: [cat.id],
//     );
//   }
// }


/* 
abstract interface class OnboardRepository {
  const OnboardRepository();

  Future<void> removeOnboard();
}

final class OnboardRepositoryImpl implements OnboardRepository {
  OnboardRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  Future<void> removeOnboard() async {}
}
*/


/*
class TestBloc extends Bloc<TestEvent, TestState> {
  final TestRepository _repository;

  TestBloc({required TestRepository repository})
      : _repository = repository,
        super(TestInitial()) {
    on<TestEvent>(
      (event, emit) => switch (event) {
        LoadTest() => _loadTest(event, emit),
      },
    );
  }

  void _loadTest(
    LoadTest event,
    Emitter<TestState> emit,
  ) {
    logger(_repository.isTest());
  }
}
*/

