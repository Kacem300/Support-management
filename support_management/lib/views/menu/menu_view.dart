import 'package:flutter/material.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

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
          icon: const Icon(Icons.search, color: Color(0xFF4ECDC4)),
          onPressed: () {
            // Handle search action
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Color(0xFF4ECDC4)),
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
                  // Navigate to Notifications
                },
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
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildMenuItem(items[index]);
      },
    );
  }

  Widget _buildMenuItem(_MenuItemData item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.icon,
                size: 24,
                color: const Color(0xFF4ECDC4),
              ),
            ),
            const Spacer(),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
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
