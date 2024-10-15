import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:weather_app/di/di.dart';

void setUpDio() {
  dio.options.baseUrl =
      'http://api.weatherapi.com/v1'; // общая часть адресов запросов
  dio.options.queryParameters.addAll({
    'api_token':
        '6bd7997c9dce42dcb9c170642240809', // сюда нужно будет подставить ключ/токен, выданный при регистрации
  });
  dio.options.connectTimeout = const Duration(minutes: 1);
  dio.options.receiveTimeout = const Duration(minutes: 1);
  dio.interceptors.addAll([
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestData: true,
        printRequestHeaders: true,
      ),
    ),
  ]);
}
