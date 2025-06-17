import 'package:flutter/material.dart';

import '../constants.dart';

class TabWidget extends StatefulWidget {
  const TabWidget({
    super.key,
    required this.titles,
    required this.pages,
  });

  final List<String> titles;
  final List<Widget> pages;

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.titles.length,
      animationDuration: Duration.zero,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 52,
          margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(
            bottom: 8,
            top: 4,
          ),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _tabController.index == _selectedIndex
                  ? const Color(0xff095EF1)
                  : null,
            ),
            indicatorWeight: 2,
            labelPadding: EdgeInsets.zero,
            labelStyle: const TextStyle(
              color: Color(0xffF2F5F8),
              fontSize: 16,
              fontFamily: AppFonts.w500,
            ),
            unselectedLabelStyle: const TextStyle(
              color: Color(0xff707883),
              fontSize: 16,
              fontFamily: AppFonts.w500,
            ),
            tabs: List.generate(
              widget.titles.length,
              (index) {
                return Tab(
                  text: widget.titles[index],
                );
              },
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.pages,
          ),
        ),
      ],
    );
  }
}
