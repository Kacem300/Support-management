import 'package:flutter/material.dart';
import '../home/home_view.dart';
import '../tickets/tickets_views.dart';
import '../clients/clients_views.dart';
import '../chat/chat_view.dart';
import '../menu/menu_view.dart';

class MainNavigationView extends StatefulWidget {
  final int initialIndex;

  const MainNavigationView({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  late int _currentIndex;
  late PageController _pageController;

  // All the main app pages - this is the single source of truth
  final List<Widget> _pages = [
    const HomeView(), // Index 0 - Home (content only)
    const TicketsView(), // Index 1 - Tickets
    const ChatView(), // Index 2 - Messages/Chat
    const ClientsView(), // Index 3 - Clients
    const MenuView(), // Index 4 - Menu
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Stack(
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
                    currentIndex: _currentIndex == 2
                        ? 0
                        : _getBottomNavIndex(), // Always valid
                    onTap: (index) {
                      int actualIndex;
                      switch (index) {
                        case 0:
                          actualIndex = 0;
                          break;
                        case 1:
                          actualIndex = 1;
                          break;
                        case 2:
                          return; // skip Messages slot
                        case 3:
                          actualIndex = 3;
                          break;
                        case 4:
                          actualIndex = 4;
                          break;
                        default:
                          return;
                      }
                      _navigateToPage(actualIndex);
                    },
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    selectedItemColor: _currentIndex == 2
                        ? Colors.grey[600]
                        : const Color(0xFF4ECDC4),
                    unselectedItemColor: Colors.grey[600],
                    selectedFontSize: 12,
                    unselectedFontSize: 11,
                    selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 11,
                    ),
                    items: [
                      BottomNavigationBarItem(
                        icon: _buildNavIcon(
                            'assets/images/home.png', 0, Icons.home),
                        label: 'Accueil',
                      ),
                      BottomNavigationBarItem(
                        icon: _buildNavIcon('assets/images/ticket.png', 1,
                            Icons.confirmation_number),
                        label: 'Tickets',
                      ),
                      // Empty space for center floating button
                      const BottomNavigationBarItem(
                        icon: SizedBox(height: 24),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: _buildNavIcon(
                            'assets/images/Clients.png', 3, Icons.people),
                        label: 'Clients',
                      ),
                      BottomNavigationBarItem(
                        icon: _buildNavIcon(
                            'assets/images/Menu.png', 4, Icons.menu),
                        label: 'Menu',
                      ),
                    ],
                  ),
                  // Indicator line directly in the column
                  Container(
                    height: 8,
                    width: double.infinity,
                    color: Colors
                        .white, // White background so black line is visible
                    child: Builder(
                      builder: (context) {
                        final indicatorWidth = 83.0;
                        final screenWidth = MediaQuery.of(context).size.width;
                        final left = _getIndicatorPosition(
                            overrideWidth: indicatorWidth);
                        final clampedLeft =
                            left.clamp(0.0, screenWidth - indicatorWidth);

                        return Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: clampedLeft, top: 2),
                            height: 3, // Exact height as specified
                            width: 83, // Exact width as specified
                            decoration: BoxDecoration(
                              color:
                                  Colors.black.withOpacity(1.0), // Full opacity
                              borderRadius: BorderRadius.circular(
                                  90), // 90px border radius
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Floating center Messages button
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 30,
              top: -30,
              child: GestureDetector(
                onTap: () => _navigateToPage(2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white, // Always white background
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x5E16A79E),
                            blurRadius: 30.3,
                            offset: const Offset(0, 4),
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
                              decoration: const BoxDecoration(
                                color: Color(
                                    0xFF4ECDC4), // Always teal background for fallback
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.message,
                                color: Colors.white, // Always white icon
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 2), // Match main_page.dart spacing
                    Text(
                      'Messages',
                      style: TextStyle(
                        fontSize: 11,
                        color: _currentIndex == 2
                            ? const Color(0xFF2E2E2E) // Selected color
                            : Colors.grey[600], // Unselected color
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
      ),
    );
  }

  Widget _buildNavIcon(String assetPath, int index, IconData fallbackIcon) {
    // Only highlight if not on Messages
    final isSelected = _currentIndex == index && _currentIndex != 2;
    return SizedBox(
      width: 24,
      height: 24,
      child: Image.asset(
        assetPath,
        width: 24,
        height: 24,
        color: isSelected ? const Color(0xFF4ECDC4) : const Color(0xFF6A6A6A),
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            fallbackIcon,
            size: 24,
            color:
                isSelected ? const Color(0xFF4ECDC4) : const Color(0xFF6A6A6A),
          );
        },
      ),
    );
  }

  int _getBottomNavIndex() {
    // Map current page index to bottom navigation index
    // Don't highlight anything when on Messages
    switch (_currentIndex) {
      case 0:
        return 0; // Accueil
      case 1:
        return 1; // Tickets
      case 2:
        return -1; // Messages - don't highlight any bottom nav item
      case 3:
        return 3; // Clients
      case 4:
        return 4; // Menu
      default:
        return 0;
    }
  }

  double _getIndicatorPosition({double overrideWidth = 50}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabWidth = screenWidth / 5; // 5 tabs total

    switch (_currentIndex) {
      case 0: // Accueil
        return tabWidth * 0.5 - overrideWidth / 2; // Center of first tab
      case 1: // Tickets
        return tabWidth * 1.5 - overrideWidth / 2; // Center of second tab
      case 2: // Messages (floating button)
        return screenWidth / 2 - overrideWidth / 2; // Center of screen
      case 3: // Clients
        return tabWidth * 3.5 - overrideWidth / 2; // Center of fourth tab
      case 4: // Menu
        return tabWidth * 4.5 - overrideWidth / 2; // Center of fifth tab
      default:
        return tabWidth * 0.5 - overrideWidth / 2;
    }
  }
}
