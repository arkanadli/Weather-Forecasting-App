import 'package:flutter/material.dart';
import 'package:realtime_weather_app/mainpage.dart';

void main(List<String> args) {
  runApp(const MyWeatherApp());
}

class MyWeatherApp extends StatelessWidget {
  const MyWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(),
      home: const MainPage(),
    );
  }
}
