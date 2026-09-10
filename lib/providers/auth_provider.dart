import 'package:flutter/material.dart';

import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider({
    AuthRepository? authRepository,
  }) : _authRepository = authRepository ?? AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> requestOtp(String phone) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.requestOtp(phone);

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp({
    required String phone,
    required String code,
    required String name,
    required String email,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.verifyOtp(
        phone: phone,
        code: code,
        name: name,
        email: email,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    notifyListeners();
  }
}