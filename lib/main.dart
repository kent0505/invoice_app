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
import 'src/features/invoice/bloc/invoice_bloc.dart';
import 'src/features/invoice/data/invoice_repository.dart';
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
      // await db.execute(SQL.invoices);
      await db.execute(SQL.business);
      // await db.execute(SQL.items);
      // await db.execute(SQL.clients);
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => InvoiceBloc(
              repository: context.read<InvoiceRepository>(),
            )..add(GetInvoices()),
          ),
          BlocProvider(
            create: (context) => BusinessBloc(
              repository: context.read<BusinessRepository>(),
            )..add(GetBusiness()),
          ),
          BlocProvider(
            create: (context) =>
                ProBloc(repository: context.read<ProRepository>())
                  ..add(
                    CheckPro(
                      identifier: Identifiers.paywall1,
                      initial: true,
                    ),
                  ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: routerConfig,
    );
  }
}
