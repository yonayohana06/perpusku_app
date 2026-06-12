import 'package:dio/dio.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../constants/api_endpoints.dart';
import '../di/service_locator.dart';
import '../services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storageService;

  AuthInterceptor(this._storageService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Ambil token dari storage
    final token = _storageService.getToken();

    // Jika token ada, sisipkan ke header Authorization
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Set format default ke JSON
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Tangkap error 401 (Unauthorized) jika token expired
    if (err.response?.statusCode == 401) {
      final isLoginEndpoint = err.requestOptions.path.contains(
        ApiEndpoints.login,
      );

      // Jika BUKAN endpoint login, berarti ini murni token expired/invalid session.
      // Lakukan force logout.
      if (!isLoginEndpoint) {
        sl<AuthCubit>().forceLogout();
      }
    }
    super.onError(err, handler);
  }
}
