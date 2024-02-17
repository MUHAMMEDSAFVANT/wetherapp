import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:task6/api/api_key.default.dart';
import 'package:task6/api/apikey.dart';
import 'package:task6/model/forcast/forcast.dart';
import 'package:task6/model/wethermodel/wether.dart';
import 'package:task6/services/provider/errorhandling/apierror.dart';

class HttpWeatherRepository {
  HttpWeatherRepository({required this.api, required this.client});
  final OpenWeatherMapAPI api;
  final http.Client client;

  Future<Forecast> getForecast({required String city}) => _getData(
        uri: api.forecast(city),
        builder: (data) => Forecast.fromJson(data),
      );

  Future<Weather> getWeather({required String city}) => _getData(
        uri: api.weather(city),
        builder: (data) => Weather.fromJson(data),
      );

  Future<T> _getData<T>({
    required Uri uri,
    required T Function(dynamic data) builder,
  }) async {
    try {
      final response = await client.get(uri);
      switch (response.statusCode) {
        case 200:
          final data = json.decode(response.body);
          return builder(data);
        case 401:
          throw InvalidApiKeyException();
        case 404:
          throw CityNotFoundException();
        default:
          throw UnknownException();
      }
    } on SocketException catch (_) {
      throw NoInternetConnectionException();
    }
  }
}

final weatherRepositoryProvider = Provider<HttpWeatherRepository>((ref) {
  const apiKey = String.fromEnvironment(
    'ea1c181f67a7e053b1d1ea3d912a5ecc',
    defaultValue: APIKeys.openWeatherAPIKey,
  );
  return HttpWeatherRepository(
    api: OpenWeatherMapAPI(apiKey),
    client: http.Client(),
  );
});