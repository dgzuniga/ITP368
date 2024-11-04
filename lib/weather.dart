import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main3485785378() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather App",
      home: Scaffold(
        appBar: AppBar(title: Text("Weather App")),
        body: WeatherPage(),
      ),
    );
  }
}

// Holds the zip code and the current temperature data
class WeatherState {
  final String statusMessage;
  WeatherState(this.statusMessage);
}

// WeatherCubit to manage API call and state changes
class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherState("Enter zip code to get weather data"));

  // Updates the state with a new message or temperature data
  void updateWeather(String newMessage) {
    emit(WeatherState(newMessage));
  }
}


class WeatherPage extends StatelessWidget {
  final TextEditingController zipCodeController = TextEditingController();

  WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WeatherCubit>(
      create: (context) => WeatherCubit(),
      child: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, weatherState) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: zipCodeController,
                  decoration: InputDecoration(labelText: 'Enter Zip Code'),
                  keyboardType: TextInputType.number,
                  onSubmitted: (zipCode) async {
                    String weatherData = await fetchWeatherData(zipCode);
                    await Future.delayed(Duration(milliseconds: 100));
                    context.read<WeatherCubit>().updateWeather(weatherData);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String zipCode = zipCodeController.text;
                  String weatherInfo = await fetchWeatherData(zipCode);
                  await Future.delayed(Duration(milliseconds: 100));
                  context.read<WeatherCubit>().updateWeather(weatherInfo);
                },
                child: Text("Get Weather"),
              ),
              SizedBox(height: 20),
              Text(weatherState.statusMessage, style: TextStyle(fontSize: 24)),
            ],
          );
        },
      ),
    );
  }

  // Function to call the Weather API using the provided zip code
  Future<String> fetchWeatherData(String zipCode) async {
    const String apiKey = 'b300889745a74bcd82e213153242210'; // API key
    final Uri apiUri = Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$zipCode');

    final response = await http.get(apiUri);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      String temperatureF = jsonData['current']['temp_f'].toString();
      return "Temperature: $temperatureF °F";
    } else {
      return "Failed to fetch weather data.";
    }
  }
}
