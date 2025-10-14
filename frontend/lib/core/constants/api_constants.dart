class ApiConstants {
  // Valor padrão pensado para desenvolvimento local em emulador Android.
  // No emulador Android use `10.0.2.2` para acessar o host da máquina.
  // Para iOS simulator e desktop/web use `http://localhost:8080`.
  // Você pode sobrescrever em tempo de build com --dart-define=API_BASE_URL="http://host:port"
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  // Endpoints Auth
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authMe = '/auth/me';
  static const String authChangePassword = '/auth/change-password';
  static const String authRefreshToken = '/auth/refresh-token';
  static const String authLogout = '/auth/logout';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authResetPassword = '/auth/reset-password';

  // Endpoints Users
  static const String users = '/users';

  // Headers
  static const String contentType = 'application/json';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  static const connectTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);
}