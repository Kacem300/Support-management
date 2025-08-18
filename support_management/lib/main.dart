import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:support_management/views/home/notifications_home_view.dart';
import 'controllers/controllers.dart';
import 'constants/constants.dart';

import 'views/splash/splash_view.dart';
import 'views/onboarding/onboarding_view.dart';
import 'views/auth/auth_views.dart';
import 'views/home/home_view.dart';
import 'views/home/filter_view.dart' as home_filter;
import 'views/tickets/tickets_views.dart';
import 'views/tickets/filter_view.dart' as tickets_filter;
import 'views/tickets/create_ticket_view.dart';
import 'views/tickets/create_ticket_continue_view.dart';
import 'views/clients/clients_views.dart';
import 'views/clients/client_filter_view.dart';

import 'views/main/main_navigation_view.dart';
import 'views/chat/chat_view.dart';
import 'views/audio/audio_recording_view.dart';
import 'views/menu/notifications_settings_view.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => TicketController()),
        ChangeNotifierProvider(create: (_) => ClientController()),
        ChangeNotifierProvider(create: (_) => OnboardingController()),
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => AudioRecordingController()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          fontFamily: 'Poppins', 
        ),
        home: const SplashView(), 
        routes: {
         
          '/splash': (context) => const SplashView(),
          '/onboarding': (context) => const OnboardingView(),
          '/login': (context) => const LoginView(), // Using new MVC view
          '/home': (context) =>
              const MainNavigationView(), // Home with navigation

          // Authentication routes - New MVC Views
          '/signup': (context) => const SignupView(),
          '/forgot-password': (context) => const ForgetPasswordView(),
          '/forget-password': (context) => const ForgetPasswordView(), // Alias
          '/enter-otp': (context) =>
              const EnterOtpView(), // Now works with optional email
          '/reset-password': (context) =>
              const ResetPasswordView(), // Now works with optional token

          // Main app routes - Updated to use MainNavigationView with initialIndex
          '/main': (context) =>
              const MainNavigationView(), // Default to home (index 0)
          '/main/home': (context) => const MainNavigationView(initialIndex: 0),
          '/main/tickets': (context) =>
              const MainNavigationView(initialIndex: 1),
          '/main/messages': (context) =>
              const MainNavigationView(initialIndex: 2),
          '/main/clients': (context) =>
              const MainNavigationView(initialIndex: 3),
          '/main/menu': (context) => const MainNavigationView(initialIndex: 4),

          // Direct page routes - New MVC Views
          '/tickets': (context) => const TicketsView(),
          '/clients': (context) => const ClientsView(),
          /*  '/menu': (context) => const MenuView(), */
          /*   '/main/clients/details': (context) => const ClientDetailsView(),*/

          '/tickets/create': (context) => const CreateTicketView(),
          '/main/tickets/create': (context) =>
              const CreateTicketView(), // Make sure this is correct
          '/main/tickets/create/continue': (context) =>
              const CreateTicketContinueView(), // Using new MVC view

          // Other functional routes
          '/messages': (context) => const ChatView(), // Updated to MVC ChatView
          '/chat': (context) => const ChatView(),
          '/record-audio': (context) => const AudioRecordingView(),

          // Filter routes - New MVC Views
          '/filter': (context) =>
              const home_filter.FilterView(), // General filter uses home filter
          '/home/filter': (context) =>
              const home_filter.FilterView(), // Home filter (our new one)
          '/clients/filter': (context) =>
              const ClientFilterView(), // Client filter
          '/main/home/filter': (context) =>
              const home_filter.FilterView(), // Updated to MVC FilterView
          '/tickets/filter': (context) =>
              const tickets_filter.TicketsFilterView(), // Tickets filter
          '/main/tickets/filter': (context) => const tickets_filter
              .TicketsFilterView(), // Updated to MVC TicketsFilterView

         

          // Notification route
          '/notifications': (context) => const NotificationsSettingsView(),
          '/home/notifications': (context) => const NotificationsHomeView(),
        },
        onGenerateRoute: (settings) {
          // Remove the client details route handling - let it be handled by normal navigation

          // Handle unknown routes - redirect to home
          return MaterialPageRoute(
            builder: (context) => const HomeView(),
          );
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
