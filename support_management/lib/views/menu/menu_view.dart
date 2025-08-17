import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../auth/login_view.dart';
import 'notifications_settings_view.dart';

class MenuView extends StatelessWidget {
  void _showLogoutModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return Container(
          width: double.infinity,
          height: 320,
          margin: const EdgeInsets.only(top: 200),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Êtes-vous sûr(e) de vouloir vous déconnecter ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 36),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFFFFF),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.grey, width: 1),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      child: const Text('Annuler',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF272626),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        // Fermer le modal d'abord (use sheetContext)
                        Navigator.of(sheetContext).pop();

                        // Small delay to let the sheet fully dismiss and avoid navigator race
                        await Future.delayed(const Duration(milliseconds: 150));

                        // Déconnecter l'utilisateur using outer context's provider
                        final authController = context.read<AuthController>();
                        await authController.logout();

                        // Schedule navigation on next frame to avoid navigator race with sheet dismissal
                        if (context.mounted) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            try {
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamedAndRemoveUntil(
                                      '/login', (route) => false);
                            } catch (_) {
                              // fallback to direct MaterialPageRoute if named route fails
                              Navigator.of(context, rootNavigator: true)
                                  .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (c) => const LoginView()),
                                (route) => false,
                              );
                            }
                          });
                        }
                      },
                      child: const Text('Déconnexion',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  const MenuView({super.key});

  void _showLanguageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Use StatefulBuilder to manage local state inside the modal
        int selectedIndex = 0;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: 374,
              height: 369,
              margin: const EdgeInsets.only(top: 443, left: 2),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.only(
                top: 28,
                right: 12,
                bottom: 28,
                left: 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with close button
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/translate.png',
                        width: 24,
                        height: 24,
                        color: const Color(0xFF14B8A6),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Choisir Votre Langue',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Language options
                  LanguageOption(
                    flag: 'assets/images/france.png',
                    label: 'Français',
                    selected: selectedIndex == 0,
                    onTap: () {
                      setState(() => selectedIndex = 0);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 16),
                  LanguageOption(
                    flag: 'assets/images/Uk.png',
                    label: 'Anglais',
                    selected: selectedIndex == 1,
                    onTap: () {
                      setState(() => selectedIndex = 1);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 16),
                  LanguageOption(
                    flag: 'assets/images/Tunisia.png',
                    label: 'Arabe',
                    selected: selectedIndex == 2,
                    onTap: () {
                      setState(() => selectedIndex = 2);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/Search.png',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            // Handle search action
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/images/notificationBell.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  // Handle notifications action
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4ECDC4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STORE Section
            const Text(
              'STORE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuGrid([
              _MenuItemData(
                icon: Icons.person_outline,
                title: 'Mon compte',
                onTap: () {
                  // Navigate to Mon compte
                },
              ),
              _MenuItemData(
                icon: Icons.people_outline,
                title: 'Équipe',
                onTap: () {
                  // Navigate to Équipe
                },
              ),
              _MenuItemData(
                icon: Icons.pie_chart_outline,
                title: 'Productivité',
                onTap: () {
                  // Navigate to Productivité
                },
              ),
              _MenuItemData(
                icon: Icons.language,
                title: 'Langues',
                onTap: () {
                  // Navigate to Langues
                },
              ),
              _MenuItemData(
                icon: Icons.brightness_6_outlined,
                title: 'Changer le mode',
                onTap: () {
                  // Navigate to Changer le mode
                },
              ),
              _MenuItemData(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsSettingsView(),
                    ),
                  );
                },
              ),
              _MenuItemData(
                icon: Icons.logout,
                title: 'Déconnexion',
                onTap: () => _showLogoutModal(context),
              ),
            ]),
            const SizedBox(height: 32),

            // SUPPORT Section
            const Text(
              'SUPPORT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuGrid([
              _MenuItemData(
                icon: Icons.inbox_outlined,
                title: 'Inbox',
                onTap: () {
                  // Navigate to Inbox
                },
              ),
              _MenuItemData(
                icon: Icons.help_outline,
                title: 'FAQ',
                onTap: () {
                  // Navigate to FAQ
                },
              ),
            ]),
            const SizedBox(height: 32),

            // SYSTEM Section
            const Text(
              'SYSTEM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuGrid([
              _MenuItemData(
                icon: Icons.extension_outlined,
                title: 'Extensions',
                onTap: () {
                  // Navigate to Extensions
                },
              ),
              _MenuItemData(
                icon: Icons.toggle_on_outlined,
                title: 'Settings',
                onTap: () {
                  // Navigate to Settings
                },
              ),
            ]),
            const SizedBox(height: 32),

            // Go Premium Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.diamond_outlined,
                      size: 24,
                      color: Color(0xFF4ECDC4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Go premium',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32), // Reduced spacing since no bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid(List<_MenuItemData> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 163 / 76, // width / height
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final itemData = items[index];
        // Intercept tap for Langues
        if (itemData.title == 'Langues') {
          return GestureDetector(
            onTap: () => _showLanguageModal(context),
            child: _buildMenuItem(itemData),
          );
        }
        // Wrap all other items with GestureDetector for onTap
        return GestureDetector(
          onTap: itemData.onTap,
          child: _buildMenuItem(itemData),
        );
      },
    );
  }
}

Widget _buildMenuItem(_MenuItemData item) {
  // Map titles to asset icons
  final Map<String, String> iconAssets = {
    'Mon compte': 'assets/images/profileMenu.png',
    'Équipe': 'assets/images/profile-2user.png',
    'Productivité': 'assets/images/icon.png',
    'Langues': 'assets/images/translate.png',
    'Changer le mode': 'assets/images/sun.png',
    'Notifications': 'assets/images/notification.png',
    'Inbox': 'assets/images/Inbox.png',
    'Extensions': 'assets/images/Extensions.png',
    'Settings': 'assets/images/Settings.png',
    'Go premium': 'assets/images/premium.png',
  };
  final String? assetPath = iconAssets[item.title];
  return Container(
    width: 163,
    height: 76,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: assetPath != null
              ? Image.asset(
                  assetPath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                )
              : Icon(
                  item.icon,
                  size: 24,
                  color: const Color(0xFF4ECDC4),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          item.title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            fontSize: 13,
            height: 1.0,
            letterSpacing: 0.75,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _MenuItemData({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

// Language option widget for modal
class LanguageOption extends StatelessWidget {
  final String flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const LanguageOption({
    super.key,
    required this.flag,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 63,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF4ECDC4) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              flag,
              width: 52,
              height: 42,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 18 / 16, // line-height: 18px
                  letterSpacing: 0,
                  color: Color(0xFF4A4F54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
