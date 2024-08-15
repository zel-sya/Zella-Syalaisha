import 'package:flutter/material.dart';
import 'package:weather_zella/weather.dart';
import 'package:weather_zella/weather_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky View',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 195, 232, 241),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController controller = TextEditingController();
  WeatherService weatherService = WeatherService();
  Weather? weather;  // Nullable Weather
  bool isFetch = false;
  bool isLoading = false;  // State untuk memantau loading

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      // Mengatur cuaca hanya jika kotak teks kosong
      if (controller.text.isEmpty) {
        setState(() {
          isFetch = false;
          weather = null;  // Mengatur weather menjadi null saat teks kosong
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 13, 155, 221),
        title: Text(
          'Weather Track',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true, // Menjadikan judul berada di tengah
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              CircularProgressIndicator(),  // Menampilkan indikator loading saat isLoading true
            if (!isLoading && isFetch && weather != null) ...[
              Image.network(
                'https://openweathermap.org/img/wn/${weather!.icon}@2x.png',
                width: 100,
                height: 100,
              ),
              Text(
                '${weather!.temp.toStringAsFixed(1)}°C',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                weather!.desc,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
            Container(
              width: 150,
              padding: EdgeInsets.symmetric(vertical: 50),
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Enter city name',
                  labelStyle: TextStyle(
                    color: Colors.black, 
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    isLoading = true;  // Memulai loading
                    isFetch = false;   // Menyembunyikan data cuaca sebelumnya saat loading
                  });

                  try {
                    final fetchedWeather = await weatherService.fetchData(controller.text);
                    setState(() {
                      weather = fetchedWeather;
                      isFetch = true;
                      isLoading = false;  // Selesai loading
                    });
                  } catch (e) {
                    setState(() {
                      isLoading = false;  // Selesai loading walaupun terjadi error
                      isFetch = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to load weather data')),
                    );
                  }
                } else {
                  setState(() {
                    isFetch = false;
                    weather = null;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Warna latar belakang button
                foregroundColor: Colors.white, // Warna teks button
              ),
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
