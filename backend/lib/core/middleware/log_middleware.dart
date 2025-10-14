import 'package:shelf/shelf.dart';

Middleware customLogMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      final startTime = DateTime.now();

      print('→ ${request.method} ${request.url}');

      final response = await handler(request);

      final duration = DateTime.now().difference(startTime);
      final status = response.statusCode;
      final statusEmoji = status >= 200 && status < 300 ? '✅' : '❌';

      print(
          '← $statusEmoji $status ${request.method} ${request.url} (${duration.inMilliseconds}ms)');

      return response;
    };
  };
}
