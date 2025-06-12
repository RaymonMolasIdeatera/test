import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECENT ACTIVITY',
              style: AppTextStyles.overline.copyWith(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to transactions
              },
              child: Text(
                'View All',
                style: AppTextStyles.buttonSmall.copyWith(
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Sample transactions
        _TransactionItem(
          title: 'Welcome Bonus',
          subtitle: 'Registration reward',
          amount: '+100 CBNK',
          time: 'Today',
          icon: Icons.celebration,
          isIncoming: true,
        ),
        _TransactionItem(
          title: 'Referral Bonus',
          subtitle: 'New member joined',
          amount: '+50 CBNK',
          time: 'Yesterday',
          icon: Icons.group_add,
          isIncoming: true,
        ),
        _TransactionItem(
          title: 'System Update',
          subtitle: 'Account verification',
          amount: '+0 CBNK',
          time: '2 days ago',
          icon: Icons.verified,
          isIncoming: false,
          isNeutral: true,
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String time;
  final IconData icon;
  final bool isIncoming;
  final bool isNeutral;

  const _TransactionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.icon,
    required this.isIncoming,
    this.isNeutral = false,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    Color amountColor;

    if (isNeutral) {
      iconColor = AppColors.info;
      amountColor = AppColors.textSecondary;
    } else if (isIncoming) {
      iconColor = AppColors.success;
      amountColor = AppColors.success;
    } else {
      iconColor = AppColors.error;
      amountColor = AppColors.error;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textHint.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
