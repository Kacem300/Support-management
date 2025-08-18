import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/controllers.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  authController.user?.name ?? 'Kacem Ben Brahim',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(6, 6, 32, 0.08),
                    offset: const Offset(0, 4),
                    blurRadius: 40,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home/notifications');
                },
                icon: Image.asset(
                  'assets/images/notificationBell.png',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.notifications_outlined,
                      color: Colors.grey,
                      size: 24,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
