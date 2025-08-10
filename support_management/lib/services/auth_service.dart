import '../models/models.dart';

abstract class AuthService {
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> signup(String email, String password, String name);
  Future<bool> logout();
  Future<bool> forgotPassword(String email);
  Future<bool> resetPassword(String token, String newPassword);
  Future<bool> verifyOtp(String email, String otp);
  Future<UserModel?> getCurrentUser();
  Future<bool> isLoggedIn();
}

class AuthServiceImpl implements AuthService {
  // Mock implementation - replace with actual API calls
  static UserModel? _currentUser;

  @override
  Future<UserModel?> login(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Mock successful login
    _currentUser = UserModel(
      id: '1',
      email: email,
      name: 'John Doe',
      createdAt: DateTime.now(),
      avatar: 'assets/images/default_avatar.png',
    );

    return _currentUser;
  }

  @override
  Future<UserModel?> signup(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw Exception('All fields are required');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Mock successful signup
    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      createdAt: DateTime.now(),
    );

    return _currentUser;
  }

  @override
  Future<bool> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    return true;
  }

  @override
  Future<bool> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));

    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Mock sending reset email
    return true;
  }

  @override
  Future<bool> resetPassword(String token, String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));

    if (token.isEmpty || newPassword.length < 6) {
      throw Exception('Invalid token or password too short');
    }

    return true;
  }

  @override
  Future<bool> verifyOtp(String email, String otp) async {
    await Future.delayed(const Duration(seconds: 1));

    if (otp.length != 6) {
      throw Exception('OTP must be 6 digits');
    }

    return true;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<bool> isLoggedIn() async {
    return _currentUser != null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
}
