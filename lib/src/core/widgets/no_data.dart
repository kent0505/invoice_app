import 'package:flutter/material.dart';

import '../constants.dart';

class NoData extends StatefulWidget {
  const NoData({super.key});

  @override
  State<NoData> createState() => _NoDataState();
}

class _NoDataState extends State<NoData> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 400),
        opacity: _opacity,
        child: const Text(
          'No data',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: AppFonts.w600,
          ),
        ),
      ),
    );
  }
}
