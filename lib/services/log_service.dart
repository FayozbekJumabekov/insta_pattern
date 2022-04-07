import 'package:insta_pattern/services/http_service.dart';
import 'package:logger/logger.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  static void d(String message) {
    if (Network.isTester) _logger.d(message);
  }

  static void i(String message) {
    if (Network.isTester) _logger.i(message);
  }

  static void e(String message) {
    if (Network.isTester) _logger.e(message);
  }

  static void w(String message) {
    if (Network.isTester) _logger.w(message);
  }
}
