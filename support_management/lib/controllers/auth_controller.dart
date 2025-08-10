import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthServiceImpl();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  // Public methods
  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      final user = await _authService.login(email, password);
      _setUser(user);

      return user != null;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signup(String email, String password, String name) async {
    try {
      _setLoading(true);
      _setError(null);

      final user = await _authService.signup(email, password, name);
      _setUser(user);

      return user != null;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> logout() async {
    try {
      _setLoading(true);
      _setError(null);

      final success = await _authService.logout();
      if (success) {
        _setUser(null);
      }

      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);

      return await _authService.forgotPassword(email);
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      _setLoading(true);
      _setError(null);

      return await _authService.resetPassword(token, newPassword);
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      _setLoading(true);
      _setError(null);

      return await _authService.verifyOtp(email, otp);
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authService.getCurrentUser();
        _setUser(user);
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  void clearError() {
    _setError(null);
  }
}
