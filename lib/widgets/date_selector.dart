import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

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
                // Handle previous week navigation
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
          const Text(
            '13 Apr - 19 Apr',
            style: TextStyle(
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
                // Handle next week navigation
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
}
