import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../business/screens/business_screen.dart';
import '../../client/screens/clients_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routePath = '/SettingsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'User',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: AppFonts.w600,
            ),
          ),
          const SizedBox(height: 22),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgWidget(Assets.star),
              SizedBox(width: 5),
              Text(
                'Plus Weekly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: AppFonts.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Renews on 12.05.2025',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff748098),
              fontSize: 8,
              fontFamily: AppFonts.w400,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                _Tile(
                  title: 'Personal Account',
                  hasIcon: true,
                  onPressed: () {},
                ),
                _Tile(
                  title: 'Business Information',
                  hasIcon: true,
                  onPressed: () {
                    context.push(BusinessScreen.routePath);
                  },
                ),
                _Tile(
                  title: 'Clients',
                  hasIcon: true,
                  onPressed: () {
                    context.push(ClientsScreen.routePath);
                  },
                ),
                _Tile(
                  title: 'Items',
                  hasIcon: true,
                  onPressed: () {},
                ),
                _Tile(
                  title: 'Privacy',
                  onPressed: () {},
                ),
                _Tile(
                  title: 'Terms',
                  onPressed: () {},
                ),
                _Tile(
                  title: 'Contact',
                  onPressed: () {},
                ),
                _Tile(
                  title: 'Rate App',
                  onPressed: () {},
                ),
                _Tile(
                  title: 'Share App',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.title,
    this.hasIcon = false,
    required this.onPressed,
  });

  final String title;
  final bool hasIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.4,
              color: Color(0xff545456).withValues(alpha: 0.34),
            ),
          ),
        ),
        height: 44,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: AppFonts.w400,
                ),
              ),
            ),
            if (hasIcon) ...const [
              SvgWidget(Assets.right),
              SizedBox(width: 20),
            ]
          ],
        ),
      ),
    );
  }
}
