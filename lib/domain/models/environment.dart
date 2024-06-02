import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Environment{
  static String get apiKey {
    return dotenv.env['API_KEY'] ?? '';
  }
}