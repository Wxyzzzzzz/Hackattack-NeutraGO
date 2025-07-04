import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthChanged;
  const DateSelector(
      {super.key, required this.selectedMonth, required this.onMonthChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 49,
      color: const Color(0xFF153462),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Arrow
          Padding(
            padding: const EdgeInsets.only(left: 19),
            child: GestureDetector(
              onTap: () {
                // Go to previous month
                final prevMonth =
                    DateTime(selectedMonth.year, selectedMonth.month - 1);
                onMonthChanged(prevMonth);
              },
              child: Container(
                width: 27,
                height: 27,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF153462),
                  size: 16,
                ),
              ),
            ),
          ),

          // Date Range Text
          Text(
            '${_monthName(selectedMonth.month)} ${selectedMonth.year}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              fontFamily: 'Open Sans',
            ),
          ),

          // Right Arrow
          Padding(
            padding: const EdgeInsets.only(right: 19),
            child: GestureDetector(
              onTap: () {
                // Go to next month
                final nextMonth =
                    DateTime(selectedMonth.year, selectedMonth.month + 1);
                onMonthChanged(nextMonth);
              },
              child: Container(
                width: 27,
                height: 27,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF153462),
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
