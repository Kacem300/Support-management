// Legacy screen placeholders for gradual migration
import 'package:flutter/material.dart';
import '../common/placeholder_view.dart';

// Screens that need to be migrated from old structure
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Splash Screen',
      message: 'Use SplashView instead - this is a legacy placeholder',
      icon: Icons.autorenew,
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Onboarding',
      message: 'Use OnboardingView instead - this is a legacy placeholder',
      icon: Icons.ondemand_video,
    );
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Signup',
      message: 'Use SignupView instead - this is a legacy placeholder',
      icon: Icons.person_add,
    );
  }
}

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Forgot Password',
      message: 'Use ForgotPasswordView instead - this is a legacy placeholder',
      icon: Icons.lock_reset,
    );
  }
}

class EnterOtpScreen extends StatelessWidget {
  const EnterOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Enter OTP',
      message: 'Use EnterOtpView instead - this is a legacy placeholder',
      icon: Icons.pin,
    );
  }
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Reset Password',
      message: 'Use ResetPasswordView instead - this is a legacy placeholder',
      icon: Icons.lock_reset,
    );
  }
}

class MainPage extends StatelessWidget {
  final int initialIndex;

  const MainPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Main Page',
      message: 'Use MainPageView instead - this is a legacy placeholder',
      icon: Icons.home,
    );
  }
}

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Filter',
      message: 'Use FilterView instead - this is a legacy placeholder',
      icon: Icons.filter_list,
    );
  }
}

class CreateTicketPage extends StatelessWidget {
  const CreateTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Create Ticket',
      message: 'Use CreateTicketView instead - this is a legacy placeholder',
      icon: Icons.add_task,
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Chat',
      message: 'Use ChatView instead - this is a legacy placeholder',
      icon: Icons.chat,
    );
  }
}

class ClientDetailsPage extends StatelessWidget {
  final String clientId;
  final String clientName;
  final String joinDate;
  final bool isActive;
  final int ticketsInProgress;
  final int ticketsResolved;
  final String avatar;

  const ClientDetailsPage({
    super.key,
    required this.clientId,
    required this.clientName,
    required this.joinDate,
    required this.isActive,
    required this.ticketsInProgress,
    required this.ticketsResolved,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return PlaceholderView(
      title: 'Client Details',
      message:
          'Client: $clientName\nUse ClientDetailsView instead - this is a legacy placeholder',
      icon: Icons.person,
    );
  }
}
