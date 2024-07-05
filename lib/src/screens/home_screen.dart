import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/Screens/weather_details_screen.dart';


import '../provider/weather_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();


  // Future<void> _loadLastCityWeather() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? lastCity = prefs.getString('last_city');
  //   if (lastCity != null && lastCity.isNotEmpty) {
  //     _fetchWeather(cityName: lastCity);
  //   }
  // }
  //
  // Future<void> _saveLastCityWeather(String cityName) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('last_city', cityName);
  // }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<weatherProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200]?.withOpacity(0.6),
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
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

                    if (!provider.isLoading && provider.weather != null ) {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => WeatherDetailsScreen(weather: provider.weather!, onReload: () async {await provider.fetchWeather(cityName: cityName);},
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to fetch weather data'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                },
                child: Text('Get Weather'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
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
              SizedBox(height: 50.0),
              provider.isLoading ? CircularProgressIndicator() : SizedBox(),
              SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}
