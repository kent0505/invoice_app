import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

import 'button.dart';
import 'svg_widget.dart';

class DatePick extends StatefulWidget {
  const DatePick({super.key, required this.date});

  final DateTime date;

  static Future<DateTime> show(
    BuildContext context,
    DateTime date,
  ) async {
    final d = await showDialog<DateTime>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return DatePick(date: date);
      },
    );
    return d ?? date;
  }

  @override
  State<DatePick> createState() => _DatePickState();
}

class _DatePickState extends State<DatePick> {
  late DateTime _current;
  DateTime _selected = DateTime.now();

  void _changeMonth(int offset) {
    setState(() {
      _current = DateTime(_current.year, _current.month + offset, 1);
    });
  }

  List<DateTime> _generateMonthDays(DateTime current) {
    final firstDay = DateTime(current.year, current.month, 1);
    int startWeekday = (firstDay.weekday + 6) % 7;
    DateTime firstVisibleDate = firstDay.subtract(Duration(days: startWeekday));
    return List.generate(42, (i) => firstVisibleDate.add(Duration(days: i)));
  }

  List<DateTime> _getWeek(DateTime date, int index) {
    return _generateMonthDays(date).skip(index * 7).take(7).toList();
  }

  @override
  void initState() {
    super.initState();
    _current = widget.date;
    _selected = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('MMMM yyyy').format(_current),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: AppFonts.w400,
                    ),
                  ),
                ),
                Button(
                  onPressed: () => _changeMonth(-1),
                  child: const SvgWidget(
                    Assets.prev,
                    color: Color(0xffFF4400),
                  ),
                ),
                SizedBox(width: 8),
                Button(
                  onPressed: () => _changeMonth(1),
                  child: const SvgWidget(
                    Assets.next,
                    color: Color(0xffFF4400),
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                _Weekday('MON'),
                _Weekday('TUE'),
                _Weekday('WED'),
                _Weekday('THU'),
                _Weekday('FRI'),
                _Weekday('SAT'),
                _Weekday('SUN'),
              ],
            ),
            Column(
              children: List.generate(6, (weekIndex) {
                return Row(
                  children: _getWeek(_current, weekIndex).map((date) {
                    return _Day(
                      date: date,
                      current: _current,
                      selected: _selected == date,
                      onPressed: () {
                        context.pop(date);
                      },
                    );
                  }).toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _Day extends StatelessWidget {
  const _Day({
    required this.date,
    required this.current,
    required this.selected,
    required this.onPressed,
  });

  final DateTime date;
  final DateTime current;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today =
        date.day == now.day && date.month == now.month && date.year == now.year;

    return SizedBox(
      height: 44,
      width: 44,
      child: Column(
        children: [
          Button(
            onPressed: date.month == current.month ? onPressed : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xffFF4400).withValues(alpha: 0.12)
                    : null,
                borderRadius: BorderRadius.circular(44),
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: date.month == current.month
                        ? selected || today
                            ? const Color(0xffFF4400)
                            : Colors.black
                        : Colors.transparent,
                    fontSize: selected ? 24 : 20,
                    fontFamily: selected ? AppFonts.w500 : AppFonts.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Weekday extends StatelessWidget {
  const _Weekday(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 32,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Color(0xff3C3C43).withValues(alpha: 0.3),
            fontSize: 12,
            fontFamily: AppFonts.w600,
          ),
        ),
      ),
    );
  }
}
