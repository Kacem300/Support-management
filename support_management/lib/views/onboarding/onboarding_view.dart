import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/controllers.dart';
import '../../constants/constants.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Initialize onboarding data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingController>().initialize();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    await context.read<OnboardingController>().completeOnboarding();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _skipOnboarding() async {
    await context.read<OnboardingController>().skipOnboarding();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<OnboardingController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => controller.initialize(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.items.isEmpty) {
            return const Center(
              child: Text('No onboarding data available'),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                // PageView for onboarding content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      controller.goToPage(index);
                    },
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      return OnboardingPage(
                        data: controller.items[index],
                        pageIndex: index,
                        pageController: _pageController,
                        onSkip: _skipOnboarding,
                      );
                    },
                  ),
                ),

                // Bottom navigation section
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  child: controller.isLastPage
                      ? _buildLastPageNavigation(controller)
                      : _buildRegularNavigation(controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRegularNavigation(OnboardingController controller) {
    return Row(
      children: [
        // Back button
        if (!controller.isFirstPage)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              onPressed: () {
                controller.previousPage();
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
              controller.items.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: controller.currentIndex == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: controller.currentIndex == index
                      ? const Color(0xFF4ECDC4)
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
              controller.nextPage();
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

  Widget _buildLastPageNavigation(OnboardingController controller) {
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
              controller.previousPage();
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
}

class OnboardingPage extends StatefulWidget {
  final dynamic data; // Can be OnboardingModel from service
  final int pageIndex;
  final PageController pageController;
  final VoidCallback onSkip;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.pageIndex,
    required this.pageController,
    required this.onSkip,
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
        rightPosition = -circleWidth * 0.3;
        leftPosition = null;
        break;
      case 1: // Center alignment - circle in the center
        leftPosition = (MediaQuery.of(context).size.width - circleWidth) / 2;
        rightPosition = null;
        break;
      case 2: // Left alignment - circle positioned to the left
        leftPosition = -circleWidth * 0.3;
        rightPosition = null;
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
                    decoration: const BoxDecoration(
                      color: Color(0xFF4ECDC4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Skip button at top right
                if (widget.pageIndex < 5) // Don't show skip on last page
                  Positioned(
                    top: 20,
                    right: 20,
                    child: TextButton(
                      onPressed: widget.onSkip,
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
                        duration: const Duration(milliseconds: 500),
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
