import 'package:logger/logger.dart';

class LoggerService {
  static final Logger logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      printEmojis: true,
    ),
  );
}
