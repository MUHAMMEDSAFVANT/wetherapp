import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task6/model/forcast/forcast_data.dart';
import 'package:task6/model/wethermodel/wether_data.dart';
import 'package:task6/services/provider/errorhandling/whetherrepo.dart';

final cityProvider = StateProvider<String>((ref) {
  return 'London';
});

final currentWeatherProvider =
    FutureProvider.autoDispose<WeatherData>((ref) async {
  final city = ref.watch(cityProvider);
  final weather =
      await ref.watch(weatherRepositoryProvider).getWeather(city: city);
  return WeatherData.from(weather);
});

final hourlyWeatherProvider =
    FutureProvider.autoDispose<ForecastData>((ref) async {
  final city = ref.watch(cityProvider);
  final forecast =
      await ref.watch(weatherRepositoryProvider).getForecast(city: city);
  return ForecastData.from(forecast);
});