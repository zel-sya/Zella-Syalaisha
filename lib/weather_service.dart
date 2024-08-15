import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_zella/weather.dart';

// https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}

class WeatherService {
  Future<Weather> fetchData(String cityName) async {
    try {
      final queryParameters = {
        'q' : cityName,
        'appid' : 'a8d0770dc3bf906ed6ca4ae3cba597a1',
        'units' : 'metric'
    };
    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', queryParameters);
    final response = await http.get(uri);
    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));  
    } else{
      throw Exception('failed');
    }
    } catch (e) {
      rethrow;
      
    }
  }
}