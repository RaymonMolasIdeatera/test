import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/user.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  final VoidCallback onEditPressed;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTeal.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar and Edit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.background.withOpacity(0.2),
                backgroundImage:
                    user.avatarUrl != null
                        ? NetworkImage(user.avatarUrl!)
                        : null,
                child:
                    user.avatarUrl == null
                        ? Text(
                          user.name?.isNotEmpty == true
                              ? user.name![0].toUpperCase()
                              : 'U',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : null,
              ),
              IconButton(
                onPressed: onEditPressed,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.background,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Name and Username
          Text(
            user.name ?? 'CryptoBank User',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.background,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '@${user.username ?? 'user'}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.background.withOpacity(0.8),
            ),
          ),

          const SizedBox(height: 16),

          // Member Since
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Member since ${_formatDate(user.createdAt)}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.background.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
