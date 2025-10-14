import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/features/auth/presentation/auth_routes.dart';
import 'package:backend/features/users/presentation/user_routes.dart';
import 'package:backend/features/egressos/presentation/egresso_routes.dart';
import 'package:backend/features/publicacoes/presentation/publicacao_routes.dart';
import 'package:backend/features/eventos/presentation/evento_routes.dart';
import 'package:backend/features/parceiros/presentation/parceiro_routes.dart';
import 'package:backend/features/beneficios/presentation/beneficio_routes.dart';
import 'package:backend/features/historias/presentation/historia_routes.dart';
import 'package:backend/features/notificacoes/presentation/notificacao_routes.dart';
import 'package:backend/features/carteirinhas/presentation/carteirinha_routes.dart';
import 'package:backend/features/documentos_carteirinha/presentation/documento_routes.dart';
import 'package:backend/features/beneficios_resgates/presentation/beneficio_resgate_routes.dart';
import 'package:backend/core/middleware/auth_middleware.dart';
import 'package:backend/core/middleware/cors_middleware.dart';
import 'package:backend/core/middleware/log_middleware.dart';

class AppRoutes {
  Router get router {
    final router = Router();

    router.get('/health', (Request req) {
      return Response.ok(
        '{"status":"ok","timestamp":"${DateTime.now().toIso8601String()}"}',
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.mount('/auth', AuthRoutes().router);

    router.mount(
      '/users',
      Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler(UserRoutes().router),
    );

    router.mount(
        '/egressos',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(EgressoRoutes().router));

    router.mount(
        '/publicacoes',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(PublicacaoRoutes().router));

    router.mount(
        '/eventos',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(EventoRoutes().router));

    router.mount(
        '/parceiros',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(ParceiroRoutes().router));

    router.mount(
        '/beneficios',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(BeneficioRoutes().router));

    router.mount(
        '/historias',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(HistoriaRoutes().router));

    router.mount(
        '/notificacoes',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(NotificacaoRoutes().router));

    router.mount(
        '/carteirinhas',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(CarteirinhaRoutes().router));

    router.mount(
        '/documentos',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(DocumentoRoutes().router));
            
    router.mount(
        '/beneficios-resgates',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(BeneficioResgateRoutes().router));

    return router;
  }

  Handler get handler {
    return Pipeline()
        .addMiddleware(corsMiddleware())
        .addMiddleware(customLogMiddleware())
        .addMiddleware(logRequests())
        .addHandler(router);
  }
}
