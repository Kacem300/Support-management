import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../constants/constants.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textFadeAnimation;

  bool _showLogo = true;
  bool _showText = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create fade animations
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    _startSplashSequence();
  }

  void _startSplashSequence() async {
    // Show logo first
    _logoController.forward();

    // Wait 2 seconds, then fade out logo and show text
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Vérifier la session utilisateur
    final authController = Provider.of<AuthController>(context, listen: false);
    await authController.checkAuthStatus();
    if (authController.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    setState(() {
      _showLogo = false;
      _showText = true;
    });

    _textController.forward();

    // Wait 2 more seconds, then navigate to onboarding
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: _showLogo
                ? _buildLogoScreen()
                : _showText
                    ? _buildTextScreen()
                    : Container(),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoScreen() {
    return FadeTransition(
      opacity: _logoFadeAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            child: Image.asset(
              'assets/images/aftercodelogo.png',
              height: 150,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if logo image is not found
                return Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(75),
                  ),
                  child: const Icon(
                    Icons.business,
                    size: 80,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextScreen() {
    return FadeTransition(
      opacity: _textFadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              AppStrings.splashTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              AppStrings.splashSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
