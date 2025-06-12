import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class OAuthProviderButton extends StatelessWidget {
  final String provider;
  final bool isSelected;
  final VoidCallback onTap;

  const OAuthProviderButton({
    super.key,
    required this.provider,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryTeal.withOpacity(0.1)
                  : AppColors.surfaceColor,
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.textHint,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _getProviderColor(),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(_getProviderIcon(), color: Colors.white, size: 16),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getProviderName(),
                    style: AppTextStyles.labelLarge.copyWith(
                      color:
                          isSelected
                              ? AppColors.primaryTeal
                              : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _getProviderDescription(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryTeal,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  String _getProviderName() {
    switch (provider) {
      case 'google':
        return 'Continue with Google';
      case 'apple':
        return 'Continue with Apple';
      case 'facebook':
        return 'Continue with Facebook';
      default:
        return 'Unknown Provider';
    }
  }

  String _getProviderDescription() {
    switch (provider) {
      case 'google':
        return 'Use your Google account to sign in';
      case 'apple':
        return 'Use your Apple ID to sign in';
      case 'facebook':
        return 'Use your Facebook account to sign in';
      default:
        return '';
    }
  }

  IconData _getProviderIcon() {
    switch (provider) {
      case 'google':
        return Icons.g_mobiledata;
      case 'apple':
        return Icons.apple;
      case 'facebook':
        return Icons.facebook;
      default:
        return Icons.login;
    }
  }

  Color _getProviderColor() {
    switch (provider) {
      case 'google':
        return const Color(0xFF4285F4);
      case 'apple':
        return const Color(0xFF000000);
      case 'facebook':
        return const Color(0xFF1877F2);
      default:
        return AppColors.textHint;
    }
  }
}
