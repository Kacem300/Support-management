class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.example.com/v1';
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 32;
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 1000;

  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 500;
  static const int longAnimationDuration = 1000;

  // Image Constraints
  static const double maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif'
  ];

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Regex Patterns
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';

  // Default Values
  static const String defaultAvatar = 'assets/images/default_avatar.png';
  static const String defaultLogo = 'assets/images/aftercodelogo.png';
}
