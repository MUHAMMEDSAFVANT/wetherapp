library forecast;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task6/model/wethermodel/wether.dart';
part 'forcast.g.dart';
part 'forcast.freezed.dart';

@freezed
class Forecast with _$Forecast {
  factory Forecast({
    required List<Weather> list,
  }) = _Forecast;

  factory Forecast.fromJson(Map<String, dynamic> json) =>
      _$ForecastFromJson(json);
}