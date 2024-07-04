import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/src/Screens/weather_details_screen.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/Services/weather_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService('f69eab89030e780c9514c4820eceb91d');
  Weather? _weathers;
  bool _isLoading = false;

  _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    String cityName = _searchController.text.isNotEmpty ? _searchController.text : await _weatherService.getCurrentCity();
    try {
      Weather weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weathers = weather;
        _isLoading = false;
      });

      // Navigate to details screen when weather is fetched successfully
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WeatherDetailsScreen(weather: weather)),
      );
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make scaffold background transparent
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back.jpg"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.0), // Adjust spacing for the title
              Text(
                "Welcome to Weather App",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.0), // Adjust spacing between title and input fields
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
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200]?.withOpacity(0.6), // Adjust opacity if needed
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _fetchWeather,
                child: Text('Get Weather'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0), // Adjust spacing between button and text
              Text(
                "Please enter your city to get the weather",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 50.0), // Adjust spacing below the instructions
              _isLoading
                  ? CircularProgressIndicator()
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,

              ),
              SizedBox(height: 50.0), // Adjust spacing at the bottom
            ],
          ),
        ),
      ),
    );
  }
}