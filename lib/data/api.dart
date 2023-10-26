import 'package:dio/dio.dart';

class ApiClient{
  final Dio _api = Dio();

  Future<dynamic> getGPSFromCityName(String city) async {
    final info = await _api.get('http://api.positionstack.com/v1/forward?access_key=32c7fb94e449f9805edd69501b9c4a82&query=${city}');
    return info.data;
  }
  Future<dynamic> getWeatherForLocation(double lng, double lat) async {
    final info = await _api.get('https://weather-proxy.freecodecamp.rocks/api/current?lat=${lat}&lon=${lng}');
    return info.data;
  }


}