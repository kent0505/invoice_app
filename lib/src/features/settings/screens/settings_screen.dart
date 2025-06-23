import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../business/screens/business_screen.dart';
import '../../client/screens/clients_screen.dart';
import '../../item/screens/items_screen.dart';
import '../../pro/bloc/pro_bloc.dart';
import '../../pro/models/pro.dart';

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
          // Center(
          //   child: Container(
          //     height: 50,
          //     width: 50,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 4),
          // Text(
          //   'User',
          //   textAlign: TextAlign.center,
          //   style: const TextStyle(
          //     color: Colors.black,
          //     fontSize: 16,
          //     fontFamily: AppFonts.w600,
          //   ),
          // ),
          // const SizedBox(height: 22),
          BlocBuilder<ProBloc, Pro>(
            builder: (context, state) {
              return state.isPro && isIOS()
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SvgWidget(Assets.star),
                            const SizedBox(width: 5),
                            Text(
                              state.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontFamily: AppFonts.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Renews on ${state.expireDate}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xff748098),
                            fontSize: 8,
                            fontFamily: AppFonts.w400,
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                    )
                  : const SizedBox();
            },
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                // _Tile(
                //   title: 'Personal Account',
                //   hasIcon: true,
                //   onPressed: () {},
                // ),
                _Tile(
                  title: 'Business Information',
                  hasIcon: true,
                  onPressed: () {
                    context.push(
                      BusinessScreen.routePath,
                      extra: false,
                    );
                  },
                ),
                _Tile(
                  title: 'Clients',
                  hasIcon: true,
                  onPressed: () {
                    context.push(
                      ClientsScreen.routePath,
                      extra: false,
                    );
                  },
                ),
                _Tile(
                  title: 'Items',
                  hasIcon: true,
                  onPressed: () {
                    context.push(
                      ItemsScreen.routePath,
                      extra: false,
                    );
                  },
                ),

                _Tile(
                  title: 'Privacy Policy',
                  onPressed: () async {
                    final Uri url = Uri.parse(
                        'https://docs.google.com/document/d/13WZ7lio-8L5SXEA00rpU28H1bpckcBx_4PLjzTeHqg0/edit?usp=sharing');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                ),
                _Tile(
                  title: 'Terms & Conditions',
                  onPressed: () async {
                    final Uri url = Uri.parse(
                        'https://docs.google.com/document/d/123xMfvJu0xCYnm8-mYv9YcCIhBr5NqFhwP7fewTeNvI/edit?usp=sharing');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                ),
                _Tile(
                  title: 'Contact us',
                  onPressed: () async {
                    final Uri url =
                        Uri.parse('https://forms.gle/eG28LimZKZVWbhd7A');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                ),
                _Tile(
                  title: 'Rate App',
                  onPressed: () async {
                    final InAppReview inAppReview = InAppReview.instance;
                    if (await inAppReview.isAvailable()) {
                      await inAppReview.requestReview();
                    } else {
                      await inAppReview.openStoreListing();
                    }
                  },
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
