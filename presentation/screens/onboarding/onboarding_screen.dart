import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/common/crypto_bank_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.security,
      title: 'Secure & Private',
      description:
          'Your financial data is protected with bank-level security and biometric authentication.',
    ),
    OnboardingPage(
      icon: Icons.group_add,
      title: 'Invitation Only',
      description:
          'Join an exclusive community through our invitation-only system and grow your network.',
    ),
    OnboardingPage(
      icon: Icons.smart_toy,
      title: 'AI-Powered',
      description:
          'Get personalized financial insights and manage your money with our intelligent assistant.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: _goToInvitation,
                    child: Text(
                      'Skip',
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),

              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Page Indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: const WormEffect(
                    activeDotColor: AppColors.primaryTeal,
                    dotColor: AppColors.textHint,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 16,
                  ),
                ),
              ),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.all(24),
                child:
                    _currentPage == _pages.length - 1
                        ? CryptoBankButton(
                          onPressed: _goToInvitation,
                          text: 'Get Started',
                          width: double.infinity,
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: _goToInvitation,
                              child: Text(
                                'Skip',
                                style: AppTextStyles.buttonMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            CryptoBankButton(
                              onPressed: _nextPage,
                              text: 'Next',
                              width: 120,
                            ),
                          ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.primaryTeal.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(page.icon, size: 60, color: AppColors.primaryTeal),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            page.description,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.mediumAnimation,
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToInvitation() {
    Navigator.of(context).pushReplacementNamed(AppConstants.invitationRoute);
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}
