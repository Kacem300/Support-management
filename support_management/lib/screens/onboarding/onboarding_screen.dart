import 'package:flutter/material.dart';
import 'onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() {
    // Navigate to main app or login screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildRegularNavigation() {
    return Row(
      children: [
        // Back button
        if (_currentPage > 0)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          )
        else
          const SizedBox(width: 50),

        // Page indicator dots centered
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? const Color(0xFF4ECDC4)
                      // ignore: deprecated_member_use
                      : Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),

        // Next button
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25),
          ),
          child: IconButton(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastPageNavigation() {
    return Row(
      children: [
        // Back button
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25),
          ),
          child: IconButton(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),

        const Spacer(),

        // "Commencer" button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextButton(
            onPressed: _completeOnboarding,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Commencer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // PageView for onboarding content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: onboardingData[index],
                    pageIndex: index,
                    pageController: _pageController,
                  );
                },
              ),
            ),

            // Bottom navigation section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: _currentPage == onboardingData.length - 1
                  ? _buildLastPageNavigation()
                  : _buildRegularNavigation(),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  final OnboardingItem data;
  final int pageIndex;
  final PageController pageController;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.pageIndex,
    required this.pageController,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  double _opacity = 0.5;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_onPageScroll);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_onPageScroll);
    super.dispose();
  }

  void _onPageScroll() {
    if (widget.pageController.page != null) {
      final currentPage = widget.pageController.page!;
      final distance = (currentPage - widget.pageIndex).abs();

      // Calculate opacity based on distance from current page
      // When distance is 0 (current page), opacity is 1
      // When distance is 1 (next/previous page), opacity is 0
      final newOpacity = (1.0 - distance).clamp(0.0, 1.0);

      // Calculate scale with a subtle effect
      final newScale = 0.85 + (0.15 * newOpacity);

      if (mounted) {
        setState(() {
          _opacity = newOpacity;
          _scale = newScale;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the background positioning based on page index
    double? leftPosition;
    double? rightPosition;
    double circleWidth = MediaQuery.of(context).size.width * 1.3;
    double circleHeight = MediaQuery.of(context).size.width * 1.3;

    switch (widget.pageIndex % 3) {
      case 0: // Right alignment - circle positioned to the right
        rightPosition =
            -circleWidth * 0.3; // Push circle to the right, half hidden
        leftPosition = null;
        circleWidth = MediaQuery.of(context).size.width * 1.3;
        circleHeight = MediaQuery.of(context).size.width * 1.3;
        break;
      case 1: // Center alignment - circle in the center
        leftPosition = (MediaQuery.of(context).size.width - circleWidth) / 2;
        rightPosition = null;
        circleWidth = MediaQuery.of(context).size.width * 1.3;
        circleHeight = MediaQuery.of(context).size.width * 1.3;
        break;
      case 2: // Left alignment - circle positioned to the left
        leftPosition =
            -circleWidth * 0.3; // Push circle to the left, half hidden
        rightPosition = null;
        circleWidth = MediaQuery.of(context).size.width * 1.3;
        circleHeight = MediaQuery.of(context).size.width * 1.3;
        break;
    }

    return Column(
      children: [
        // Top curved section with illustration
        Expanded(
          flex: 3,
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                // Dynamic circular background
                Positioned(
                  left: leftPosition,
                  right: rightPosition,
                  top: (MediaQuery.of(context).size.height * 0.6 -
                          circleHeight) /
                      2,
                  child: Container(
                    width: circleWidth,
                    height: circleHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Skip button at top right
                if (widget.pageIndex < 7) // Don't show skip on last page
                  Positioned(
                    top: 20,
                    right: 20,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Passer',
                        style: TextStyle(
                          color: Color(0xFF47464F),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                // Illustration
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    child: Transform.scale(
                      scale: _scale,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: _opacity,
                        child: widget.data.imagePath.isNotEmpty
                            ? Image.asset(
                                widget.data.imagePath,
                                fit: BoxFit.contain,
                                height: 300,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholderIcon(
                                      widget.pageIndex);
                                },
                              )
                            : _buildPlaceholderIcon(widget.pageIndex),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom white section with text
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Title
                Text(
                  widget.data.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  widget.data.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderIcon(int index) {
    final icons = [
      Icons.folder_open,
      Icons.track_changes,
      Icons.group_work,
      Icons.favorite,
      Icons.auto_awesome,
      Icons.celebration,
    ];

    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(125),
      ),
      child: Icon(
        icons[index % icons.length],
        size: 100,
        color: Colors.white,
      ),
    );
  }
}
