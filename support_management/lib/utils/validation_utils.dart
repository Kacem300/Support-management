class ValidationUtils {
  /// Validate email address
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;

    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    return RegExp(emailPattern).hasMatch(email);
  }

  /// Validate password strength
  static bool isValidPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    return password.length >= 6;
  }

  /// Validate phone number
  static bool isValidPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) return false;

    const phonePattern = r'^\+?[1-9]\d{1,14}$';
    return RegExp(phonePattern).hasMatch(phoneNumber);
  }

  /// Check if string is not empty
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Check if string has minimum length
  static bool hasMinLength(String? value, int minLength) {
    return value != null && value.length >= minLength;
  }

  /// Check if string has maximum length
  static bool hasMaxLength(String? value, int maxLength) {
    return value == null || value.length <= maxLength;
  }

  /// Validate string is within length range
  static bool isValidLength(String? value, int minLength, int maxLength) {
    return hasMinLength(value, minLength) && hasMaxLength(value, maxLength);
  }

  /// Check if two passwords match
  static bool passwordsMatch(String? password, String? confirmPassword) {
    return password != null &&
        confirmPassword != null &&
        password == confirmPassword;
  }

  /// Validate name (only letters and spaces)
  static bool isValidName(String? name) {
    if (name == null || name.trim().isEmpty) return false;

    const namePattern = r'^[a-zA-Z\s]+$';
    return RegExp(namePattern).hasMatch(name.trim());
  }

  /// Get email validation error message
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Get password validation error message
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (!isValidPassword(password)) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  /// Get name validation error message
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    if (!isValidName(name)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  /// Get phone validation error message
  static String? validatePhone(String? phone) {
    if (phone != null && phone.isNotEmpty && !isValidPhoneNumber(phone)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Get confirm password validation error message
  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (!passwordsMatch(password, confirmPassword)) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Get required field validation error message
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Get length validation error message
  static String? validateLength(String? value, int minLength, int maxLength,
      {String fieldName = 'Field'}) {
    if (value == null) return null;

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }
    if (value.length > maxLength) {
      return '$fieldName must be no more than $maxLength characters long';
    }
    return null;
  }
}
