import 'package:backend/routes/app_routes.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Handler buildServer() {
  final router = AppRoutes().router;

  final pipeline = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router);

  return pipeline;
}
