import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen_new.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forget_password_screen.dart';
import 'screens/auth/enter_otp_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/home/main_page.dart';
import 'screens/home/filter_page.dart';
import 'screens/tickets/create_ticket_page.dart';
import 'screens/tickets/create_ticket_continue_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Support Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4ECDC4)),
        useMaterial3: true,
        fontFamily: 'Inter', // You can add custom fonts later
      ),
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forget-password': (context) => const ForgetPasswordScreen(),
        '/enter-otp': (context) => const EnterOtpScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/main': (context) => const MainPage(),
        '/main/menu': (context) => const MainPage(initialIndex: 4),
        '/main/home': (context) => const MainPage(initialIndex: 0),
        '/main/tickets': (context) => const MainPage(initialIndex: 1),
        '/main/home/filter': (context) => const FilterPage(),
        '/main/tickets/create': (context) => const CreateTicketPage(),
        '/main/tickets/create/continue': (context) =>
            const CreateTicketContinuePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
