import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFF4ECDC4)),
            onPressed: () {
              // Handle notifications action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                icon: 'assets/images/Sales.png',
                title: 'Sales',
                onTap: () {
                  // Navigate to Sales
                },
              ),
              _MenuItemData(
                icon: 'assets/images/Products.png',
                title: 'Products',
                onTap: () {
                  // Navigate to Products
                },
              ),
              _MenuItemData(
                icon: 'assets/images/Earnings.png',
                title: 'Earnings',
                onTap: () {
                  // Navigate to Earnings
                },
              ),
              _MenuItemData(
                icon: 'assets/images/Traffic.png',
                title: 'Traffic',
                onTap: () {
                  // Navigate to Traffic
                },
              ),
              _MenuItemData(
                icon: 'assets/images/Conversion.png',
                title: 'Conversion',
                onTap: () {
                  // Navigate to Conversion
                },
              ),
              _MenuItemData(
                icon: 'assets/images/Marketing.png',
                title: 'Marketing',
                onTap: () {
                  // Navigate to Marketing
                },
              ),
              _MenuItemData(
                icon: 'assets/images/Payouts.png',
                title: 'Payouts',
                onTap: () {
                  // Navigate to Payouts
                },
              ),
            ]),
            const SizedBox(height: 24),

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
                icon: 'assets/images/ticket.png',
                title: 'Tickets',
                onTap: () {
                  Navigator.pushNamed(context, '/main', arguments: 1);
                },
              ),
              _MenuItemData(
                icon: 'assets/images/Inbox.png',
                title: 'Inbox',
                onTap: () {
                  // Navigate to Inbox
                },
              ),
              _MenuItemData(
                icon: 'assets/images/FAQ.png',
                title: 'FAQ',
                onTap: () {
                  // Navigate to FAQ
                },
              ),
            ]),
            const SizedBox(height: 24),

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
                icon: 'assets/images/Extensions.png',
                title: 'Extensions',
                onTap: () {
                  // Navigate to Extensions
                },
              ),
              _MenuItemData(
                icon: 'assets/images/Settings.png',
                title: 'Settings',
                onTap: () {
                  // Navigate to Settings
                },
              ),
            ]),
            const SizedBox(height: 32), // Extra bottom spacing for scroll
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
              child: Center(
                child: Image.asset(
                  item.icon,
                  width: 24,
                  height: 24,
                  color: const Color(0xFF4ECDC4),
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      _getDefaultIcon(item.title),
                      size: 24,
                      color: const Color(0xFF4ECDC4),
                    );
                  },
                ),
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

  IconData _getDefaultIcon(String title) {
    switch (title.toLowerCase()) {
      case 'sales':
        return Icons.shopping_cart_outlined;
      case 'products':
        return Icons.inventory_2_outlined;
      case 'earnings':
        return Icons.trending_up;
      case 'traffic':
        return Icons.public;
      case 'conversion':
        return Icons.show_chart;
      case 'marketing':
        return Icons.campaign;
      case 'payouts':
        return Icons.attach_money;
      case 'tickets':
        return Icons.confirmation_number;
      case 'inbox':
        return Icons.inbox;
      case 'faq':
        return Icons.help_outline;
      case 'extensions':
        return Icons.extension;
      case 'settings':
        return Icons.settings;
      default:
        return Icons.apps;
    }
  }
}

class _MenuItemData {
  final String icon;
  final String title;
  final VoidCallback onTap;

  _MenuItemData({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
