import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather/additional.dart';
import 'package:weather/forcastCard.dart';
import 'package:http/http.dart' as http;
import 'package:weather/secrate.dart';

class screenweather extends StatefulWidget {
  const screenweather({super.key});

  @override
  State<screenweather> createState() => _screenweatherState();
}

class _screenweatherState extends State<screenweather> {
  // double temp = 0;
  // bool isloading = false;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getcurrentweather();
  // }

  Future<Map<String, dynamic>> getcurrentweather() async {
    try {
      String cityName = 'London';
      final res = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openkey'));
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'unexpected error';
      }
      return data;
      //  data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
        actions: [IconButton(onPressed: () { setState(() {
          
        });}, icon: Icon(Icons.refresh))],
      ),
      body: FutureBuilder(
        future: getcurrentweather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindspeed = currentWeatherData['wind']['speed'];
          final currenthumidity = currentWeatherData['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp k',
                                style: TextStyle(fontSize: 32),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                currentSky,
                                style: TextStyle(fontSize: 24),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Weather Forcast',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for(int i=0 ; i <5 ; i++)
                //       forcastCard(
                //         time: data['list'][i+1]['dt'].toString(),
                //         tem: data['list'][i+1]['main']['temp'].toString(),
                //         icon: data['list'][i+1]['weather'][0]['main'] == 'Clouds' ||  data['list'][i+1]['weather'][0]['main'] == 'Rain'? Icons.cloud : Icons.sunny,
                //       ),

                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final hourlyforcast = data['list'][index + 1];
                        final hourlycloud =
                            data['list'][index + 1]['weather'][0]['main'];
                        return forcastCard(
                          time: hourlyforcast['dt_txt'].toString(),
                          tem: hourlyforcast['main']['temp'].toString(),
                          icon: hourlycloud == 'Clouds' || hourlycloud == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                        );
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Additional Forcast'),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    additionalifo(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: currenthumidity.toString(),
                    ),
                    additionalifo(
                        icon: Icons.air,
                        label: 'Wind speed',
                        value: currentWindspeed.toString()),
                    additionalifo(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
