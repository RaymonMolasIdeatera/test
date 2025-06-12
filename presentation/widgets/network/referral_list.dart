import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/affiliate_network.dart';
import '../common/crypto_bank_loading.dart';

class ReferralList extends StatelessWidget {
  final List<AffiliateNetwork> affiliateNetwork;
  final bool isLoading;

  const ReferralList({
    super.key,
    required this.affiliateNetwork,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REFERRAL NETWORK',
          style: AppTextStyles.overline.copyWith(
            color: AppColors.primaryTeal,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        if (isLoading)
          const Center(child: CryptoBankLoading(size: 30))
        else if (affiliateNetwork.isEmpty)
          _EmptyState()
        else
          Column(
            children:
                affiliateNetwork.map((referral) {
                  return _ReferralItem(referral: referral);
                }).toList(),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textHint.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.group_add_outlined, size: 48, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(
            'No Referrals Yet',
            style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Start inviting friends to build your network and earn rewards!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ReferralItem extends StatelessWidget {
  final AffiliateNetwork referral;

  const _ReferralItem({required this.referral});

  @override
  Widget build(BuildContext context) {
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
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryTeal.withOpacity(0.1),
            child: Text(
              referral.name.isNotEmpty ? referral.name[0].toUpperCase() : 'U',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  referral.name.isNotEmpty ? referral.name : 'Anonymous User',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@${referral.username}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Level and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getLevelColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'L${referral.level}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _getLevelColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      referral.status == 'active'
                          ? AppColors.success
                          : AppColors.textHint,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getLevelColor() {
    switch (referral.level) {
      case 1:
        return AppColors.gold;
      case 2:
        return AppColors.silver;
      case 3:
        return AppColors.accent;
      default:
        return AppColors.textHint;
    }
  }
}
