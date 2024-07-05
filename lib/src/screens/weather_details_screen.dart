import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/src/models/weather_model.dart';

String getWeatherAnimation(String mainCondition) {
  switch (mainCondition.toLowerCase()) {
    case 'clouds':
    case 'mist':
    case 'smoke':
    case 'haze':
    case 'dust':
    case 'fog':
      return 'assets/cloud.json'; // Return cloud animation for these conditions

    case 'rain':
    case 'drizzle':
    case 'shower rain':
      return 'assets/rain.json'; // Return rain animation for these conditions

    case 'thunderstorm':
      return 'assets/thunder.json'; // Return thunderstorm animation for this condition

    case 'clear':
      return 'assets/sunny.json'; // Return sunny animation for clear condition

    default:
      return 'assets/sunny.json'; // Default to sunny animation for unknown conditions
  }
}

class WeatherDetailsScreen extends StatelessWidget {
  final Weather weather;
  final VoidCallback onReload;

  WeatherDetailsScreen({required this.weather, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make scaffold background transparent
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/back.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.blue.withOpacity(0.5),
                  BlendMode.overlay,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Large Weather Icon
                    Lottie.asset(
                      getWeatherAnimation(weather.description),
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 16.0),
                    // Weather Details Card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      color: Colors.white.withOpacity(0.9), // Adjust opacity to blend with background
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'City: ${weather.cityName}',
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Temperature: ${weather.temperature.toString()}°C',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Description: ${weather.description}',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Humidity: ${weather.humidity.toString()}%',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    // Reload Weather Button
                    ElevatedButton.icon(
                      onPressed: onReload,
                      icon: Icon(Icons.refresh),
                      label: Text('Reload Weather'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    // Search Another City Button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Search Another City'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
