import 'package:flutter/material.dart';

IconData findIcon({required String degree}) {
  if (double.parse(degree) >= 25) {
    return Icons.sunny;
  } else if (double.parse(degree) >= 20) {
    return Icons.cloud;
  } else {
    return Icons.cloudy_snowing;
  }
}

class HourlyForecastItem extends StatelessWidget {
  final String time;
  // final IconData icon;
  final String degree;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.degree,
  });

  @override
  Widget build(BuildContext context) {
    final icon = findIcon(degree: degree);
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
      ),
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Icon(
              icon,
              size: 32,
            ),
            Text(
              degree,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }
}
