import 'package:postgres/postgres.dart';
import '../config/env.dart';

class Database {
  static Connection? _connection;

  static Future<Connection> connect() async {
    if (_connection == null) {
      final endpoint = Endpoint(
        host: Env.dbHost,
        port: Env.dbPort,
        database: Env.dbName,
        username: Env.dbUser,
        password: Env.dbPass,
      );

      final settings = ConnectionSettings(
        sslMode: SslMode.disable,
      );

      _connection = await Connection.open(endpoint, settings: settings);
      print('✅ Conectado ao PostgreSQL em ${Env.dbHost}:${Env.dbPort}');
    }

    return _connection!;
  }

  static Future<void> close() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
      print('🔌 Conexão com o banco fechada.');
    }
  }
}
