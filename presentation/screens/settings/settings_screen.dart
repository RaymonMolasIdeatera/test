import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../bloc/auth/auth_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Section
            _SectionHeader(title: 'Security'),
            _SettingsItem(
              icon: Icons.fingerprint,
              title: 'Biometric Authentication',
              subtitle: 'Use fingerprint or face recognition',
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Toggle biometric setting
                },
              ),
            ),
            _SettingsItem(
              icon: Icons.lock_outline,
              title: 'Change PIN',
              subtitle: 'Update your security PIN',
              onTap: () => _showComingSoon(context, 'Change PIN'),
            ),
            _SettingsItem(
              icon: Icons.devices,
              title: 'Manage Devices',
              subtitle: 'View and manage authorized devices',
              onTap: () => _showComingSoon(context, 'Manage Devices'),
            ),

            const SizedBox(height: 24),

            // Preferences Section
            _SectionHeader(title: 'Preferences'),
            _SettingsItem(
              icon: Icons.notifications_on_outlined,
              title: 'Notifications',
              subtitle: 'Push notifications and alerts',
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Toggle notifications
                },
              ),
            ),
            _SettingsItem(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'App appearance theme',
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Toggle dark mode
                },
              ),
            ),
            _SettingsItem(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: 'English (US)',
              onTap: () => _showComingSoon(context, 'Language'),
            ),

            const SizedBox(height: 24),

            // Support Section
            _SectionHeader(title: 'Support'),
            _SettingsItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Get help and support',
              onTap: () => _showComingSoon(context, 'Help Center'),
            ),
            _SettingsItem(
              icon: Icons.feedback_outlined,
              title: 'Send Feedback',
              subtitle: 'Share your thoughts with us',
              onTap: () => _showComingSoon(context, 'Send Feedback'),
            ),
            _SettingsItem(
              icon: Icons.bug_report_outlined,
              title: 'Report a Bug',
              subtitle: 'Report technical issues',
              onTap: () => _showComingSoon(context, 'Report a Bug'),
            ),

            const SizedBox(height: 24),

            // About Section
            _SectionHeader(title: 'About'),
            _SettingsItem(
              icon: Icons.info_outline,
              title: 'About CryptoBank',
              subtitle: 'Version 1.0.0 (MVP)',
              onTap: () => _showAboutDialog(context),
            ),
            _SettingsItem(
              icon: Icons.policy_outlined,
              title: 'Privacy Policy',
              subtitle: 'How we protect your data',
              onTap: () => _showComingSoon(context, 'Privacy Policy'),
            ),
            _SettingsItem(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Legal terms and conditions',
              onTap: () => _showComingSoon(context, 'Terms of Service'),
            ),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('About CryptoBank', style: AppTextStyles.h4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Version 1.0.0 (MVP)',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'CryptoBank is a next-generation financial platform combining blockchain technology with AI assistance and comprehensive financial management tools.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '"The future is now"',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryTeal,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
              'Are you sure you want to logout? You will need to authenticate again to access your account.',
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

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.overline.copyWith(
          color: AppColors.primaryTeal,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryTeal),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing:
            trailing ??
            (onTap != null
                ? const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textHint,
                  size: 16,
                )
                : null),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: AppColors.surfaceColor,
      ),
    );
  }
}
