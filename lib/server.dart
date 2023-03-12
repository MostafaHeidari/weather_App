import 'dart:convert';   /*The dart:convert library provides the json object, which has methods to encode and decode JSON data. The jsonEncode() method converts a Dart object to a JSON-encoded string, and the jsonDecode() method converts a JSON-encoded string to a Dart object.*/
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

const String baseAssetURL =
    'https://dartpad-workshops-io2021.web.app/getting_started_with_slivers/assets';
const String headerImage = '${baseAssetURL}/header.jpeg';



const String baseForecastUrl =
    'https://api.open-meteo.com/v1/forecast?hourly=temperature_2m,apparent_temperature,precipitation_probability,precipitation,windspeed_10m,winddirection_10m&daily=weathercode,temperature_2m_max,temperature_2m_min,windspeed_10m_max&windspeed_unit=ms&timezone=auto';
    //'https://api.open-meteo.com/v1/forecast?hourly=temperature_2m,apparent_temperature,precipitation_probability,precipitation,windspeed_10m,winddirection_10m&daily=weathercode,temperature_2m_max,temperature_2m_min&windspeed_unit=ms&timezone=auto';
    //'https://api.open-meteo.com/v1/forecast?hourly=temperature_2m,apparent_temperature,precipitation_probability,precipitation&daily=weathercode,temperature_2m_max,temperature_2m_min&windspeed_unit=ms&timezone=auto';

class Server {
  static Map<String, dynamic>? _data;

  static restore() async {
    /*static method called restore() that retrieves previously saved data from the device's memory using the SharedPreferences package. */
    final prefs = await SharedPreferences.getInstance();
    final jsonString = await prefs.getString('forecast');
    if (jsonString == null) return;
    _data = json.decode(jsonString);
  }

  static save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_data);
    await prefs.setString('forecast', jsonString);
  }

  static refresh() async {                                     /*a static method called refresh() that fetches the latest data from a weather API using the http package in Flutter.*/
    final position = await _determinePosition();               /*The refresh() method likely begins by calling the _determinePosition() method, which retrieves the device's current location using a package like geolocator. The latitude and longitude of the device's current location are then likely used to construct a URL that is passed to the weather API.*/
    final url =
        '$baseForecastUrl&latitude=${position.latitude}&longitude=${position.longitude}';   /*The URL constructed in this code is likely based on a base URL stored in a constant variable called baseForecastUrl, which is appended with the latitude and longitude obtained from _determinePosition(). This URL is likely used to fetch the latest weather data from the weather API using an HTTP GET request.*/
    print(url);
    final response = await http.get(Uri.parse(url));
    final jsonString = response.body;
    _data = json.decode(jsonString);                       /*Once the data is retrieved, the _data variable is likely updated with the decoded JSON data by calling the json.decode() method.*/
  }

  static List<DailyForecast> getDailyForecast() {          /*static method called getDailyForecast() that returns a list of DailyForecast objects. The method assumes that _data is a Map object that contains a key called 'daily' that maps to a JSON-encoded list of daily forecast data.*/
    if (_data == null) return [];
    final daily = _data!['daily'] as Map<String, dynamic>;
    return DailyForecast.fromJson(daily);
  }

  static List<HourlyForecast> getHourlyForecast() {
    if (_data == null) return [];
    final hourly = _data!['hourly'] as Map<String, dynamic>;
    return HourlyForecast.fromJson(hourly);
  }

  static Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}