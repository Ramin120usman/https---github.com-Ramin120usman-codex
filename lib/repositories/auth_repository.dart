import '../core/network/dio_client.dart';
import '../core/storage/token_storage.dart';

class AuthRepository {
  final DioClient _dioClient;
  final TokenStorage _tokenStorage;

  AuthRepository({
    DioClient? dioClient,
    TokenStorage? tokenStorage,
  })  : _dioClient = dioClient ?? DioClient(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  Future<void> requestOtp(String phone) async {
    await _dioClient.dio.post(
      '/api/v1/customer/auth/otp/request',
      data: {
        'phone': phone,
      },
    );
  }

  Future<void> verifyOtp({
    required String phone,
    required String code,
    required String name,
    required String email,
  }) async {
    final response = await _dioClient.dio.post(
      '/api/v1/customer/auth/otp/verify',
      data: {
        'phone': phone,
        'code': code,
        'name': name,
        'email': email,
      },
    );

    final data = response.data['data'];

    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];

    await _tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> logout() async {
    try {
      await _dioClient.dio.post(
        '/api/v1/customer/auth/logout',
      );
    } finally {
      await _tokenStorage.clearTokens();
    }
  }
}