import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../widgets/common/crypto_bank_loading.dart';
import '../../../widgets/profile/profile_header.dart';
import '../../../widgets/profile/profile_menu.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CryptoBankLoading(size: 50));
        }

        if (state is UserError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: 16),
                Text('Profile Unavailable', style: AppTextStyles.h4),
                const SizedBox(height: 8),
                Text(
                  'Unable to load profile information',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is UserLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                ProfileHeader(
                  user: state.user,
                  onEditPressed: () => _showEditProfile(context, state.user),
                ),

                const SizedBox(height: 24),

                // Profile Menu
                ProfileMenu(
                  onSettingsPressed: () {
                    Navigator.of(context).pushNamed(AppConstants.settingsRoute);
                  },
                  onLogoutPressed: () => _showLogoutDialog(context),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  void _showEditProfile(BuildContext context, user) {
    // Show edit profile dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Edit Profile', style: AppTextStyles.h4),
            content: Text(
              'Profile editing feature coming soon!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Logout', style: AppTextStyles.h4),
            content: Text(
              'Are you sure you want to logout?',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppConstants.splashRoute,
                    (route) => false,
                  );
                },
                child: Text(
                  'Logout',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
