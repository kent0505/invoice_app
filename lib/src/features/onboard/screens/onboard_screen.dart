import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../home/screens/home_screen.dart';
import '../data/onboard_repository.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  static const String routePath = '/OnboardScreen';

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int index = 0;

  final pageController = PageController();

  void onSkip() async {
    await context.read<OnboardRepository>().removeOnboard();
    if (mounted) {
      context.go(
        HomeScreen.routePath,
        extra: true,
      );
    }
  }

  void onPageChanged(int value) {
    setState(() {
      index = value;
    });
    if (index == 3) {
      onSkip();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff3D3D3D),
              Color(0xff141212),
            ],
          ),
        ),
        child: FittedBox(
          child: SizedBox(
            height: 813,
            width: 375,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      onPressed: onSkip,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: AppFonts.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 90,
                    child: Column(
                      children: [
                        Text(
                          index == 0
                              ? 'Welcome to Receipts'
                              : index == 1
                                  ? 'Full control over your invoices'
                                  : 'Simple and intuitive',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: AppFonts.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          index == 0
                              ? 'Create professional invoices in seconds.'
                              : index == 1
                                  ? 'Generate, edit, and send invoices from your phone.'
                                  : 'User-friendly interface with flexible settings.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: AppFonts.w600,
                          ),
                        ),
                        Text(
                          index == 0
                              ? 'Perfect for freelancers, small businesses, and anyone who values their time.'
                              : index == 1
                                  ? 'Keep track of your history, monitor payments, and automate your workflow.'
                                  : 'Work easily — anywhere, anytime.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: AppFonts.w400,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 4,
                    effect: const ScaleEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 10,
                      scale: 1.5,
                      dotColor: Color(0xffD9D9D9),
                      activeDotColor: Color(0xffFF4400),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    onPageChanged: onPageChanged,
                    children: [
                      // 1
                      Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            child: Center(
                              child: ImageWidget(
                                Assets.onboard1,
                                width: 310,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 198,
                            left: 23,
                            child: Center(
                              child: ImageWidget(
                                Assets.onboard2,
                                width: 306,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 350,
                            right: 26,
                            child: Center(
                              child: ImageWidget(
                                Assets.onboard3,
                                width: 306,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 524,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                height: 48,
                                width: 326,
                                decoration: BoxDecoration(
                                  color: const Color(0xffFF4400),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xffFF4400)
                                          .withValues(alpha: 0.5),
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'Create New Invoice',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: AppFonts.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 2
                      Stack(
                        children: [
                          Positioned(
                            left: 126,
                            top: 0,
                            child: Center(
                              child: ImageWidget(
                                Assets.onboard4,
                                width: 300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 164,
                            top: 70,
                            child: Center(
                              child: ImageWidget(
                                Assets.onboard5,
                                width: 320,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 38,
                            top: 138,
                            child: Center(
                              child: ImageWidget(
                                Assets.onboard6,
                                width: 300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 3
                      Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            child: Center(
                              child: ImageWidget(
                                Assets.onboard7,
                                width: 300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 12,
                            top: 120,
                            child: Center(
                              child: ImageWidget(
                                Assets.onboard8,
                                width: 214,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 4,
                            top: 256,
                            child: Center(
                              child: ImageWidget(
                                Assets.onboard9,
                                width: 250,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 394,
                            child: Center(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: 252,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF3F3F1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ImageWidget(
                                  Assets.onboard10,
                                  width: 242,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
