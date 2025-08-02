import 'package:flutter/material.dart';
import '../Menu/menu_screen.dart';
import '../tickets/tickets_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;

  const MainPage({super.key, this.initialIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
      case 3:
        Navigator.pushNamed(context, '/clients');
        break;
      // Home, Tickets, and Menu are handled by setState above
    }
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const TicketsPage();
      case 4:
        return const MenuScreen();
      default:
        return Container(
          color: const Color(0xFFF5F5F5),
          child: const Center(
            child: Text(
              'Page not implemented yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ),
        );
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
            child: BottomNavigationBar(
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
                  icon: SizedBox(height: 40),
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
                  const SizedBox(height: 4),
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

  /* Widget _buildCenterIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/AfterCodeIcon.png',
        width: 50,
        height: 50,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading AfterCodeIcon.png: $error');
          return Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFF4ECDC4),
              shape: BoxShape.circle,
            ),
            /* child: const Center(
              child: Text(
                'A C',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ), 
            ),*/
          );
        },
      ),
    );
  } */

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
}
