import 'package:flutter/material.dart';
import '../menu/menu_view.dart';
import '../tickets/tickets_views.dart';
import '../clients/clients_views.dart';
import 'home_view.dart';

class MainPageView extends StatefulWidget {
  final int initialIndex;

  const MainPageView({super.key, this.initialIndex = 0});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if there are route arguments to set initial index
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int && args != _currentIndex) {
      setState(() {
        _currentIndex = args;
      });
    }
  }

  void _navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Don't use pushNamed for tickets since it's handled internally
    // Only use pushNamed for pages not integrated in the main navigation
    switch (index) {
      case 2:
        Navigator.pushNamed(context, '/messages');
        break;
      // Home, Tickets, Clients, and Menu are handled by setState above
    }
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const HomeView();
      case 1:
        return const TicketsView();
      case 3:
        return const ClientsView();
      case 4:
        return const MenuView(); // Ensure MenuView is displayed correctly
      default:
        return const HomeView(); // Default to home page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentPage(),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main navigation bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: _navigateToPage,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: const Color(0xFF4ECDC4),
                  unselectedItemColor: Colors.grey[600],
                  selectedFontSize: 12,
                  unselectedFontSize: 11,
                  items: [
                    BottomNavigationBarItem(
                      icon: _buildNavIcon('assets/images/home.png', 0),
                      label: 'Accueil',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildNavIcon('assets/images/ticket.png', 1),
                      label: 'Tickets',
                    ),
                    // Empty space for center icon
                    BottomNavigationBarItem(
                      icon: SizedBox(height: 35),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildNavIcon('assets/images/Clients.png', 3),
                      label: 'Clients',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildNavIcon('assets/images/Menu.png', 4),
                      label: 'Menu',
                    ),
                  ],
                ),
                // Active tab indicator - only for bottom nav items (not Messages)
                if (_currentIndex != 2)
                  Container(
                    height: 3,
                    margin: EdgeInsets.only(
                      left: _getIndicatorPosition(),
                      right: MediaQuery.of(context).size.width -
                          _getIndicatorPosition() -
                          _getIndicatorWidth(),
                      top: 0, // Right below the navigation bar
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
              ],
            ),
          ),
          // Floating center icon
          Positioned(
            left: MediaQuery.of(context).size.width / 2 -
                30, // Center horizontally
            top: -15, // Position above the navigation bar
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pushNamed(context, '/messages');
              },
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/afterIconRemove.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4ECDC4),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'ac',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 2), // Reduced height to prevent overflow
                  Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 11,
                      color: _currentIndex == 2
                          ? const Color(0xFF4ECDC4)
                          : Colors.grey[600],
                      fontWeight: _currentIndex == 2
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  // Black line indicator right below Messages text
                  if (_currentIndex == 2)
                    Container(
                      margin: const EdgeInsets.only(top: 1), // Reduced margin
                      height: 2, // Reduced height
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(String assetPath, int index) {
    final isSelected = _currentIndex == index;
    return SizedBox(
      width: 24,
      height: 24,
      child: Image.asset(
        assetPath,
        width: 24,
        height: 24,
        color: isSelected ? const Color(0xFF4ECDC4) : Colors.grey[600],
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            _getDefaultIcon(index),
            size: 24,
            color: isSelected ? const Color(0xFF4ECDC4) : Colors.grey[600],
          );
        },
      ),
    );
  }

  IconData _getDefaultIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.confirmation_number;
      case 3:
        return Icons.people;
      case 4:
        return Icons.person;
      default:
        return Icons.circle;
    }
  }

  double _getIndicatorPosition() {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabWidth = screenWidth / 5; // 5 tabs total

    switch (_currentIndex) {
      case 0: // Accueil
        return tabWidth * 0.5 - 25; // Center of first tab
      case 1: // Tickets
        return tabWidth * 1.5 - 25; // Center of second tab
      case 2: // Messages (floating button)
        return tabWidth * 2.5 - 25; // Center position
      case 3: // Clients
        return tabWidth * 3.5 - 25; // Center of fourth tab
      case 4: // Menu
        return tabWidth * 4.5 - 25; // Center of fifth tab
      default:
        return 0;
    }
  }

  double _getIndicatorWidth() {
    return 50; // Fixed width for the indicator
  }
}
