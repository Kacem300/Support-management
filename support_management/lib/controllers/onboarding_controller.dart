import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class OnboardingController extends ChangeNotifier {
  final OnboardingService _onboardingService;

  OnboardingController({OnboardingService? onboardingService})
      : _onboardingService = onboardingService ?? OnboardingService();

  int _currentIndex = 0;
  List<OnboardingModel> _items = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  int get currentIndex => _currentIndex;
  List<OnboardingModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLastPage => _currentIndex == _items.length - 1;
  bool get isFirstPage => _currentIndex == 0;
  OnboardingModel? get currentItem =>
      _items.isNotEmpty ? _items[_currentIndex] : null;

  // Initialize onboarding data
  Future<void> initialize() async {
    _setLoading(true);
    try {
      _items = await _onboardingService.getOnboardingItems();
      _clearError();
    } catch (e) {
      _setError('Failed to load onboarding data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Navigate to next page
  void nextPage() {
    if (!isLastPage) {
      _currentIndex++;
      notifyListeners();
    }
  }

  // Navigate to previous page
  void previousPage() {
    if (!isFirstPage) {
      _currentIndex--;
      notifyListeners();
    }
  }

  // Go to specific page
  void goToPage(int index) {
    if (index >= 0 && index < _items.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  // Complete onboarding
  Future<void> completeOnboarding() async {
    try {
      await _onboardingService.markOnboardingComplete();
      _clearError();
    } catch (e) {
      _setError('Failed to complete onboarding: $e');
    }
  }

  // Skip onboarding
  Future<void> skipOnboarding() async {
    try {
      await _onboardingService.skipOnboarding();
      _clearError();
    } catch (e) {
      _setError('Failed to skip onboarding: $e');
    }
  }

  // Check if onboarding should be shown
  Future<bool> shouldShowOnboarding() async {
    try {
      return await _onboardingService.shouldShowOnboarding();
    } catch (e) {
      _setError('Failed to check onboarding status: $e');
      return true; // Default to showing onboarding if error
    }
  }

  // Reset onboarding state
  void reset() {
    _currentIndex = 0;
    _clearError();
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
