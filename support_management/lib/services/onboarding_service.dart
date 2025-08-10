import '../models/models.dart';

abstract class OnboardingServiceInterface {
  Future<List<OnboardingModel>> getOnboardingItems();
  Future<void> markOnboardingComplete();
  Future<void> skipOnboarding();
  Future<bool> shouldShowOnboarding();
}

class OnboardingService implements OnboardingServiceInterface {
  // Mock implementation - replace with real API calls

  @override
  Future<List<OnboardingModel>> getOnboardingItems() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    return onboardingData;
  }

  @override
  Future<void> markOnboardingComplete() async {
    // Simulate API call to mark onboarding as complete
    await Future.delayed(const Duration(milliseconds: 300));

    // In a real app, this would save to SharedPreferences or send to API
    // For now, just simulate success
  }

  @override
  Future<void> skipOnboarding() async {
    // Simulate API call to skip onboarding
    await Future.delayed(const Duration(milliseconds: 300));

    // In a real app, this would save skip status
    // For now, just simulate success
  }

  @override
  Future<bool> shouldShowOnboarding() async {
    // Simulate checking if onboarding should be shown
    await Future.delayed(const Duration(milliseconds: 200));

    // In a real app, this would check SharedPreferences or API
    // For now, return true to always show onboarding in development
    return true;
  }
}
