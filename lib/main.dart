import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'src/core/constants.dart';
import 'src/core/router.dart';
import 'src/core/themes.dart';
import 'src/features/business/bloc/business_bloc.dart';
import 'src/features/business/data/business_repository.dart';
import 'src/features/business/models/business.dart';
import 'src/features/client/bloc/client_bloc.dart';
import 'src/features/client/data/client_repository.dart';
import 'src/features/client/models/client.dart';
import 'src/features/invoice/bloc/invoice_bloc.dart';
import 'src/features/invoice/data/invoice_repository.dart';
import 'src/features/invoice/models/invoice.dart';
import 'src/features/item/bloc/item_bloc.dart';
import 'src/features/item/data/item_repository.dart';
import 'src/features/item/models/item.dart';
import 'src/features/pro/bloc/pro_bloc.dart';
import 'src/features/pro/data/pro_repository.dart';
import 'src/features/onboard/data/onboard_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  await Purchases.configure(
    PurchasesConfiguration('appl_XOzrSgcIeAVfozHHQbvIJjGyatM'),
  );

  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'data.db');
  // await deleteDatabase(path);
  final db = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(Invoice.sql);
      await db.execute(Business.sql);
      await db.execute(Client.sql);
      await db.execute(Item.sql);
    },
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OnboardRepository>(
          create: (context) => OnboardRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<ProRepository>(
          create: (context) => ProRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<InvoiceRepository>(
          create: (context) => InvoiceRepositoryImpl(db: db),
        ),
        RepositoryProvider<BusinessRepository>(
          create: (context) => BusinessRepositoryImpl(db: db),
        ),
        RepositoryProvider<ClientRepository>(
          create: (context) => ClientRepositoryImpl(db: db),
        ),
        RepositoryProvider<ItemRepository>(
          create: (context) => ItemRepositoryImpl(db: db),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => InvoiceBloc(
              repository: context.read<InvoiceRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BusinessBloc(
              repository: context.read<BusinessRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ClientBloc(
              repository: context.read<ClientRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ItemBloc(
              repository: context.read<ItemRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProBloc(
              repository: context.read<ProRepository>(),
            )..add(CheckPro(identifier: Identifiers.paywall1)),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: theme,
          routerConfig: routerConfig,
        ),
      ),
    ),
  );
}
