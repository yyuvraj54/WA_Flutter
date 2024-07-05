import 'package:flutter/material.dart';
import 'package:weather_app/src/models/weather_model.dart';
import '../Services/weather_service.dart';

class weatherProvider extends ChangeNotifier {
  bool isLoading = false;
  Weather? weather;


  Future<void> fetchWeather({required String cityName}) async {
    final WeatherService weatherService = WeatherService('f69eab89030e780c9514c4820eceb91d');
    isLoading = true;
    notifyListeners();
    try {
      Weather fetchedWeather = await weatherService.getWeather(cityName);
      weather = fetchedWeather;
      print(weather);
    } catch (e) {
      print('Error fetching weather data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
