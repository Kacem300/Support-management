import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class PlaceholderView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final List<String> availableRoutes;

  const PlaceholderView({
    super.key,
    required this.title,
    this.message = 'This screen is being migrated to the new MVC structure.',
    this.icon = Icons.construction,
    this.availableRoutes = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (availableRoutes.isNotEmpty) ...[
                const SizedBox(height: 32),
                Text(
                  'Available Actions:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                ...availableRoutes.map((route) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            switch (route) {
                              case 'Back to Login':
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/login',
                                  (route) => false,
                                );
                                break;
                              case 'Go to Login':
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                                break;
                              case 'Go to Home':
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                                break;
                              case 'Create Ticket':
                                Navigator.pushNamed(
                                    context, '/main/tickets/create/continue');
                                break;
                              default:
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(route),
                        ),
                      ),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
