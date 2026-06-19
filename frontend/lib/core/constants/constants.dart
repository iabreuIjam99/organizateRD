import "package:flutter/foundation.dart";

class AppConstants {
  static String get baseUrl {
    if (kIsWeb) return "http://localhost:3000/api";
    return "http://10.0.2.2:3000/api";
  }

  static const String appName = "OrganizateRD";
  static const String currencyCode = "DOP";
  static const String currencySymbol = "RD\$";
}
