import 'package:flutter/material.dart';
import 'package:weather_app/data/api.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String city = 'Standort';
  double temperature = 0;
  String description = 'Beschreibung';
  String descriptionIconUrl = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Wetter App'),
            const SizedBox(height: 24),
            Text(city),
            const SizedBox(height: 16),
            Text('$temperature °C'),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (descriptionIconUrl.isNotEmpty)
                  Image.network(descriptionIconUrl),
                const SizedBox(width: 16),
                Text(description),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                  final apiClient = ApiClient();
                  await showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Stadtname eingeben:'),
                                const SizedBox(height: 24),
                                TextField(
                                  decoration: InputDecoration(labelText: 'Stadt'),
                                  onChanged: (value) => city = value,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('Okay'))
                              ],
                            ),
                      ));
                  if (city.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Stadt ungültig')));
                    return;
                  }
                  final cityInfo = await apiClient.getGPSFromCityName(city);
                  final lng = cityInfo['data'][0]['longitude'];
                  final lat = cityInfo['data'][0]['latitude'];

                  final weatherInfo =
                      await apiClient.getWeatherForLocation(lng, lat);

                  setState(() {
                    temperature = weatherInfo['main']['temp'];
                    description = weatherInfo['weather'][0]['main'];
                    descriptionIconUrl = weatherInfo['weather'][0]['icon'];
                  });
                },
                child: Text('Standort wechseln'))
          ],
        ),
      ),
    );
  }
}
