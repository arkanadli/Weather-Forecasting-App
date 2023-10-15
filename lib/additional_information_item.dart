import 'package:flutter/material.dart';

class AdditionalInformationItem extends StatelessWidget {
  final IconData icon;
  final String type;
  final String value;

  const AdditionalInformationItem({
    super.key,
    required this.icon,
    required this.type,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            size: 32,
          ),
          Text(
            type,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w300, letterSpacing: 0.5),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
