import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_asa_attribution/flutter_asa_attribution.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'src/core/appsflyer.dart';
import 'src/core/router.dart';
import 'src/core/themes.dart';
import 'src/core/utils.dart';
import 'src/features/business/bloc/business_bloc.dart';
import 'src/features/business/data/business_repository.dart';
import 'src/features/business/models/business.dart';
import 'src/features/client/bloc/client_bloc.dart';
import 'src/features/client/data/client_repository.dart';
import 'src/features/client/models/client.dart';
import 'src/features/invoice/bloc/invoice_bloc.dart';
import 'src/features/invoice/data/invoice_repository.dart';
import 'src/features/invoice/models/invoice.dart';
import 'src/features/invoice/models/photo.dart';
import 'src/features/item/bloc/item_bloc.dart';
import 'src/features/item/data/item_repository.dart';
import 'src/features/item/models/item.dart';
import 'src/features/pro/bloc/pro_bloc.dart';
import 'src/features/pro/data/pro_repository.dart';
import 'src/features/onboard/data/onboard_repository.dart';
import 'src/features/settings/data/settings_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  String? userID = prefs.getString('userID');
  bool isFirstInstall = userID == null;

  if (userID == null) {
    userID = const Uuid().v4();
    await prefs.setString('userID', userID);
  }

  await Purchases.configure(
    PurchasesConfiguration('appl_XOzrSgcIeAVfozHHQbvIJjGyatM'),
  );
  await AppTrackingTransparency.trackingAuthorizationStatus;
  await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("2cf25f97-90de-476b-ac73-6b4b6430d72c");
  await OneSignal.Notifications.requestPermission(true);
  await OneSignal.login(userID);

  if (isFirstInstall) {
    Map<String, String> tags = {
      'subscription_type': 'unpaid',
    };

    final asaData = await _fetchAppleSearchAdsData();
    if (asaData != null) {
      if (asaData['campaignId'] != null) {
        tags['campaignId'] = asaData['campaignId'].toString();
      }
      if (asaData['adGroupId'] != null) {
        tags['adGroupId'] = asaData['adGroupId'].toString();
      }
      if (asaData['keywordId'] != null) {
        tags['keywordId'] = asaData['keywordId'].toString();
      }
      if (asaData['creativeSetId'] != null) {
        tags['creativeSetId'] = asaData['creativeSetId'].toString();
      }
    }

    await OneSignal.User.addTags(tags);
  }

  final appsFlyerService = AppsFlyerService();
  await appsFlyerService.initAppsFlyer(
    devKey: 'VssG3LNA5NwZpCZ3Dd5YhQ',
    appId: 'id6747311276',
    isDebug: false,
  );

  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'data.db');
  // await deleteDatabase(path);
  final db = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(Invoice.sql);
      await db.execute(Photo.sql);
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
        RepositoryProvider<SettingsRepository>(
          create: (context) => SettingsRepositoryImpl(prefs: prefs),
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
            ),
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

Future<Map<String, dynamic>?> _fetchAppleSearchAdsData() async {
  try {
    final String? appleSearchAdsToken =
        await FlutterAsaAttribution.instance.attributionToken();
    if (appleSearchAdsToken != null) {
      const url = 'https://api-adservices.apple.com/api/v1/';
      final headers = {'Content-Type': 'text/plain'};
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: appleSearchAdsToken,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    }
  } catch (e) {
    logger('ASA Data fetch error: $e');
  }
  return null;
}
