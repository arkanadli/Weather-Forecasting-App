import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'additional_information_item.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'secrets.dart';

// the flow Create state -> init state -> build State
// even when the init state have an async function. it will not waited, but working in the background.
// so we cant have a spontanogeus value for our data displayed
// we must create a loading screen that indicates that the data have not been fetched yet

// :: Why we are using this kind of fetch method. It is supported in flutter,
// ::  and we can simplyfy the data fetched, error handling, and on loading

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<Map<String, dynamic>> refreshWeather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
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
      // ; // to access temp
      return data; // return a data that Map and key of String, and value of Dynamic
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    refreshWeather = getCurrentWeather();
    super.initState();
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
              onPressed: () {
                setState(() {
                  refreshWeather = getCurrentWeather();
                });
              },
              icon: const Icon(Icons.refresh_outlined),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        // it will build or call the builder with a data Future from future: getCW()
        future: refreshWeather,
        // snapshot is a thing to handle state in our app: loading state, data state, error state
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          // we already sure that in this line code we already handle loading and error
          // thats why we exclamation mark the snapshot.data
          // that is means the data already resolved in snapshot.data
          final data = snapshot.data!;
          final currentData = data['list'][0];
          final double currentWeatherTemp = currentData['main']['temp'] - 273;
          dynamic weatherIcon = currentData['weather'][0]['main'];
          late String weatherText;
          final double currentWind = currentData['wind']['speed'];
          final int currentPressure = currentData['main']['pressure'];
          final int currentHumidity = currentData['main']['humidity'];

          switch (weatherIcon) {
            case 'Clouds':
              weatherIcon = Icons.cloud;
              weatherText = 'Cloudy';
            case 'Rain':
              weatherIcon = Icons.cloudy_snowing;
              weatherText = 'Rainy';
            case 'Clear':
              weatherIcon = Icons.sunny;
              weatherText = 'Sunny';
          }

          // :: return real main page after handling loading and error state
          return Padding(
            // :: create padding for the entire body screen
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
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '${currentWeatherTemp.toStringAsFixed(2)}°C',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              weatherIcon,
                              size: 60,
                            ),
                            Text(
                              weatherText,
                              style: const TextStyle(
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
                // :: We are not using listview, becuase it load the entire list first before displaying it
                // SizedBox(
                //   height: 120,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: <Widget>[
                //       for (int i = 0; i < 10; i++)
                //         HourlyForecastItem(
                //           time: data['list'][i + 1]['dt'].toString(),
                //           degree: (data['list'][i + 1]['main']['temp'] - 273)
                //               .toStringAsFixed(2),
                //         ),
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: 120,
                  // :: we use ListView.builder to handle some lazy load, (A lot of list)
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        String timeHourly = hourlyForecast['dt_txt'].toString();
                        DateTime timeFormat = DateTime.parse(timeHourly);
                        // :: native ways to parse date
                        // timeHourly = timeHourly.split(' ')[1];
                        // timeHourly = timeHourly.split(':')[0];

                        return HourlyForecastItem(
                          time: DateFormat.j().format(timeFormat),
                          degree: (hourlyForecast['main']['temp'] - 273)
                              .toStringAsFixed(2),
                        );
                      }),
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

                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdditionalInformationItem(
                        icon: Icons.water_drop_rounded,
                        type: "Humidity",
                        value: "$currentHumidity",
                      ),
                      AdditionalInformationItem(
                        icon: Icons.air,
                        type: "Wind Speed",
                        value: "$currentWind",
                      ),
                      AdditionalInformationItem(
                        icon: Icons.beach_access,
                        type: "Pressure",
                        value: "$currentPressure",
                      ),
                    ],
                  ),
                )

              ],
            ),
          );
        },
      ),
    );
  }
}
