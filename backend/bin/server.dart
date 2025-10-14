import 'dart:io';
import 'package:shelf/shelf_io.dart';
import '../lib/server.dart';
import '../lib/core/config/env.dart';

Future<void> main() async {
  final handler = buildServer();
  final server = await serve(handler, InternetAddress.anyIPv4, Env.port);

  print('🚀 Servidor rodando em http://${server.address.host}:${server.port}');
}
