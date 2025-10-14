import 'package:app_egressos/features/auth/presentation/pages/welcome_screen.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/email_sent_page.dart';
import '../../features/auth/presentation/pages/signup_success_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/welcome_screen',
    routes: [
      GoRoute(
        path: "/welcome_screen",
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/email-sent',
        builder: (context, state) => const EmailSentPage(),
      ),
      GoRoute(
        path: '/signup-success',
        builder: (context, state) => const SignupSuccessPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  );
}