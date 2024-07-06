import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/src/Screens/weather_details_screen.dart';


import '../models/weather_model.dart';
import '../provider/weather_provider.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  Weather? _lastWeather;

  @override
  void initState() {
    super.initState();
    _loadLastWeather();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadLastWeather();
  }

  Future<void> _loadLastWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cityName = prefs.getString('last_city');
    if (cityName != null && cityName.isNotEmpty) {
      setState(() {
        _lastWeather = Weather(
          cityName: cityName,
          temperature: prefs.getDouble('temperature') ?? 0.0,
          mainCondition: prefs.getString('mainCondition') ?? '',
          description: prefs.getString('description') ?? '',
          windSpeed: prefs.getDouble('windSpeed') ?? 0.0,
          humidity: prefs.getInt('humidity') ?? 0,
        );
      });
    }
  }

  Future<void> _saveLastWeather(Weather weather) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_city', weather.cityName);
    await prefs.setDouble('temperature', weather.temperature);
    await prefs.setString('mainCondition', weather.mainCondition);
    await prefs.setString('description', weather.description);
    await prefs.setDouble('windSpeed', weather.windSpeed);
    await prefs.setInt('humidity', weather.humidity);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<weatherProvider>(context);
    final mq = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            height: mq.size.height,
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/back.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50.0),
                  Text(
                    "Welcome to Weather App",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for a city...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200]?.withOpacity(0.6),
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 15.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String cityName = _searchController.text;
                      if (cityName.isNotEmpty) {
                        await provider.fetchWeather(cityName: cityName);

                        if (provider.weather?.cityName == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('City not found'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          if (!provider.isLoading && provider.weather != null) {
                            await _saveLastWeather(provider.weather!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeatherDetailsScreen(
                                  weather: provider.weather!,
                                  onReload: () async {
                                    await provider.fetchWeather(
                                        cityName: cityName);
                                  },
                                ),
                              ),
                            ).then((_) => _loadLastWeather());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to fetch weather data'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: Text('Get Weather'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Please enter your city to get the weather",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  if (_lastWeather != null) ...[
                    SizedBox(height: 20.0),
                    Text(
                      "Last Report Searched",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Card(
                      color: Colors.white.withOpacity(0.8),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "City: ${_lastWeather!.cityName}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              "Temperature: ${_lastWeather!.temperature}°C",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              "Condition: ${_lastWeather!.mainCondition}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              "Description: ${_lastWeather!.description}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              "Wind Speed: ${_lastWeather!.windSpeed} m/s",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              "Humidity: ${_lastWeather!.humidity}%",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 50.0),
                  provider.isLoading ? CircularProgressIndicator() : SizedBox(),
                  SizedBox(height: 50.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}