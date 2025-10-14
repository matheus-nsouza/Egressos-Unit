import 'package:dotenv/dotenv.dart';

class Env {
  static final _env = DotEnv()..load();

  static String get dbHost => _env['DB_HOST'] ?? 'localhost';
  static int get dbPort => int.parse(_env['DB_PORT'] ?? '5432');
  static String get dbName => _env['DB_NAME'] ?? 'egressos_db';
  static String get dbUser => _env['DB_USER'] ?? 'postgres';
  static String get dbPass => _env['DB_PASS'] ?? 'senha123';
  static int get port => int.parse(_env['PORT'] ?? '8080');
}
