import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../services/auth_api_service.dart';
import '../../core/services/storage_service.dart';

class AuthRepository {
  final AuthApiService authApiService;
  final StorageService storageService;

  AuthRepository({required this.authApiService, required this.storageService});

  /// Melakukan login dan mengembalikan LoginResponseModel
  Future<LoginResponseModel> login(String username, String password) async {
    // 1. Buat request model
    final request = LoginRequestModel(username: username, password: password);

    // 2. Panggil API Service
    final response = await authApiService.login(request);

    // 3. Parsing response ke dalam Model
    final loginResponse = LoginResponseModel.fromJson(response.data);

    // 4. Simpan token jika valid
    if (loginResponse.token.isNotEmpty) {
      await storageService.saveToken(loginResponse.token);
      if (loginResponse.refreshToken.isNotEmpty) {
        await storageService.saveRefreshToken(loginResponse.refreshToken);
      }
    } else {
      throw Exception('Token tidak ditemukan dalam response API');
    }

    return loginResponse;
  }

  /// Menghapus sesi / token
  Future<void> logout() async {
    await storageService.clearToken();
  }

  /// Mengecek apakah user sudah memiliki token lokal
  bool isLoggedIn() {
    return storageService.getToken() != null;
  }
}
