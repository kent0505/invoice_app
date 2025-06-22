import 'package:go_router/go_router.dart';

import '../features/business/models/business.dart';
import '../features/business/screens/business_screen.dart';
import '../features/business/screens/create_business_screen.dart';
import '../features/business/screens/edit_business_screen.dart';
import '../features/business/screens/signature_screen.dart';
import '../features/client/models/client.dart';
import '../features/client/screens/clients_screen.dart';
import '../features/client/screens/create_client_screen.dart';
import '../features/client/screens/edit_client_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/invoice/models/invoice.dart';
import '../features/invoice/models/photo.dart';
import '../features/invoice/models/preview_data.dart';
import '../features/invoice/screens/create_invoice_screen.dart';
import '../features/invoice/screens/edit_invoice_screen.dart';
import '../features/invoice/screens/invoice_customize_screen.dart';
import '../features/invoice/screens/invoice_details_screen.dart';
import '../features/invoice/screens/invoice_preview_screen.dart';
import '../features/invoice/screens/photo_screen.dart';
import '../features/item/models/item.dart';
import '../features/item/screens/create_item_screen.dart';
import '../features/item/screens/edit_item_screen.dart';
import '../features/item/screens/items_screen.dart';
import '../features/onboard/screens/onboard_screen.dart';
import '../features/pro/screens/pro_page.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/splash/screens/splash_screen.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: OnboardScreen.routePath,
      builder: (context, state) => const OnboardScreen(),
    ),
    GoRoute(
      path: HomeScreen.routePath,
      builder: (context, state) => HomeScreen(
        onboard: state.extra as bool,
      ),
    ),

    // pro
    GoRoute(
      path: ProScreen.routePath,
      builder: (context, state) => ProScreen(
        identifier: state.extra as String,
      ),
    ),

    // settings
    GoRoute(
      path: SettingsScreen.routePath,
      builder: (context, state) => const SettingsScreen(),
    ),

    // invoice
    GoRoute(
      path: CreateInvoiceScreen.routePath,
      builder: (context, state) => CreateInvoiceScreen(
        isEstimate: state.extra as String,
      ),
    ),
    GoRoute(
      path: InvoiceDetailsScreen.routePath,
      builder: (context, state) => InvoiceDetailsScreen(
        invoice: state.extra as Invoice,
      ),
    ),
    GoRoute(
      path: InvoicePreviewScreen.routePath,
      builder: (context, state) => InvoicePreviewScreen(
        previewData: state.extra as PreviewData,
      ),
    ),
    GoRoute(
      path: InvoiceCustomizeScreen.routePath,
      builder: (context, state) => InvoiceCustomizeScreen(
        invoice: state.extra as Invoice,
      ),
    ),
    GoRoute(
      path: EditInvoiceScreen.routePath,
      builder: (context, state) => EditInvoiceScreen(
        invoice: state.extra as Invoice,
      ),
    ),
    GoRoute(
      path: PhotoScreen.routePath,
      builder: (context, state) => PhotoScreen(
        photo: state.extra as Photo,
      ),
    ),

    // business
    GoRoute(
      path: BusinessScreen.routePath,
      builder: (context, state) => BusinessScreen(
        select: state.extra as bool,
      ),
    ),
    GoRoute(
      path: CreateBusinessScreen.routePath,
      builder: (context, state) => const CreateBusinessScreen(),
    ),
    GoRoute(
      path: EditBusinessScreen.routePath,
      builder: (context, state) => EditBusinessScreen(
        business: state.extra as Business,
      ),
    ),
    GoRoute(
      path: SignatureScreen.routePath,
      builder: (context, state) => const SignatureScreen(),
    ),

    // client
    GoRoute(
      path: ClientsScreen.routePath,
      builder: (context, state) => ClientsScreen(
        select: state.extra as bool,
      ),
    ),
    GoRoute(
      path: CreateClientScreen.routePath,
      builder: (context, state) => const CreateClientScreen(),
    ),
    GoRoute(
      path: EditClientScreen.routePath,
      builder: (context, state) => EditClientScreen(
        client: state.extra as Client,
      ),
    ),

    // item
    GoRoute(
      path: ItemsScreen.routePath,
      builder: (context, state) => ItemsScreen(
        select: state.extra as bool,
      ),
    ),
    GoRoute(
      path: CreateItemScreen.routePath,
      builder: (context, state) => CreateItemScreen(
        select: state.extra as bool,
      ),
    ),
    GoRoute(
      path: EditItemScreen.routePath,
      builder: (context, state) => EditItemScreen(
        item: state.extra as Item,
      ),
    ),
  ],
);
