import 'package:flutter_dotenv/flutter_dotenv.dart';

class KeysApi {
  static String get apiUrl => dotenv.get('API_URL');
}
