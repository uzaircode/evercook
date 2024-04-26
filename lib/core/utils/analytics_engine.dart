import 'package:evercook/core/utils/logger.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsEngine {
  static final _instance = FirebaseAnalytics.instance;

  static void triggerButton() async {
    LoggerService.logger.i('Button clicked');
    await _instance.logEvent(name: 'button_click');
  }
}
