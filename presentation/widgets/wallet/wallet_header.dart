import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/user.dart';

class WalletHeader extends StatelessWidget {
  final User user;
  final double balance;
  final bool isLoading;

  const WalletHeader({
    super.key,
    required this.user,
    required this.balance,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryTeal.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wallet Address',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primaryTeal,
                ),
              ),
              IconButton(
                onPressed: () => _copyToClipboard(context),
                icon: const Icon(
                  Icons.copy_outlined,
                  color: AppColors.primaryTeal,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Wallet Address
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.textHint.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              user.walletAddress,
              style: AppTextStyles.bodySmall.copyWith(
                fontFamily: 'monospace',
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 16),

          // Balance
          Text(
            'Current Balance',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          if (isLoading)
            const SizedBox(
              width: 80,
              height: 20,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.textHint,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryTeal,
                ),
              ),
            )
          else
            Text(
              '${balance.toStringAsFixed(2)} CBNK',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: user.walletAddress));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Wallet address copied to clipboard'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
    HapticFeedback.lightImpact();
  }
}
