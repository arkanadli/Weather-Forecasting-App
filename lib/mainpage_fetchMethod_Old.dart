import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'additional_information_item.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'secrets.dart';

// the flow Create state -> init state -> build State
// even when the init state have an async function. it will not waited, but working in the background.
// so we cant have a spontanogeus value for our data displayed
// we must create a loading screen that indicates that the data have not been fetched yet

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double temp = 0;
  bool isLoading = false;

  Future getCurrentWeather() async {
    try {
      setState(() {
        // rebuild and tell the app that it is loading process
        isLoading = true;
      });
      String cityName = 'Bandung';

      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey'),
      );
      // print(res.body);
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected Error occurred'; // break an error, causing by bad request and etc..
      }
      setState(() {
        // it will state the apps to need to be reloaded, because the async get API already have a result
        // set the loading to false because process fetch has successfully solved
        isLoading = false;
        temp = data['list'][0]['main']['temp']; // to access temp
      });
    } catch (e) {
      throw e.toString();
    }

    // print(res.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.refresh_outlined),
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // :: Main Card
                  SizedBox(
                    width: double.infinity,
                    height: 190,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '$temp°K',
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              const Icon(
                                Icons.cloudy_snowing,
                                size: 60,
                              ),
                              const Text(
                                'Rain',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Weather Forecast',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const <Widget>[
                        HourlyForecastItem(
                          time: "03:00",
                          degree: "301.17",
                        ),
                        HourlyForecastItem(
                          time: "06:00",
                          degree: "302.54",
                        ),
                        HourlyForecastItem(
                          time: "09:00",
                          degree: "305.32",
                        ),
                        HourlyForecastItem(
                          time: "12:00",
                          degree: "308.48",
                        ),
                        HourlyForecastItem(
                          time: "15:00",
                          degree: "301.36",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdditionalInformationItem(
                          icon: Icons.water_drop_rounded,
                          type: "Humidity",
                          value: "94",
                        ),
                        AdditionalInformationItem(
                          icon: Icons.air,
                          type: "Wind Speed",
                          value: "7.5",
                        ),
                        AdditionalInformationItem(
                          icon: Icons.beach_access,
                          type: "Pressure",
                          value: "1000",
                        ),
                      ],
                    ),
                  )
                  // :: Forecast Card

                  // :: Additional Information
                ],
              ),
            ),
    );
  }
}
