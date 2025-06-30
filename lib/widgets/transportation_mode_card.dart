import 'package:flutter/material.dart';

class TransportationModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String emissions;
  final Color backgroundColor;

  const TransportationModeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.emissions,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            icon,
            color: Colors.black,
            size: 20,
          ),
          const SizedBox(width: 9),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          const Spacer(),
          Text(
            emissions,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
