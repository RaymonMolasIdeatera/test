import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection_container.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../widgets/common/crypto_bank_button.dart';
import '../../widgets/common/crypto_bank_loading.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: const AuthView(),
    );
  }
}

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  void _checkBiometricAvailability() {
    // Check if biometric login is available and show appropriate UI
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                Navigator.of(
                  context,
                ).pushReplacementNamed(AppConstants.homeRoute);
              } else if (state is AuthError) {
                _showErrorSnackBar(context, state.message);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Header
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primaryTeal,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryTeal.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            size: 50,
                            color: AppColors.background,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Welcome Back',
                          style: AppTextStyles.h2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Sign in to access your CryptoBank account',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Biometric Login
                  SlideTransition(
                    position: _slideAnimation,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CryptoBankButton(
                          onPressed:
                              state is AuthLoading
                                  ? null
                                  : () => _loginWithBiometric(context),
                          text:
                              state is AuthLoading
                                  ? ''
                                  : 'Sign In with Biometric',
                          width: double.infinity,
                          icon: Icons.fingerprint,
                          child:
                              state is AuthLoading
                                  ? const CryptoBankLoading(size: 20)
                                  : null,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(color: AppColors.textHint),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or continue with',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // OAuth Providers
                  SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        CryptoBankButton(
                          onPressed: () => _loginWithOAuth(context, 'google'),
                          text: 'Continue with Google',
                          width: double.infinity,
                          isOutlined: true,
                          icon: Icons.g_mobiledata,
                        ),
                        if (Theme.of(context).platform ==
                            TargetPlatform.iOS) ...[
                          const SizedBox(height: 12),
                          CryptoBankButton(
                            onPressed: () => _loginWithOAuth(context, 'apple'),
                            text: 'Continue with Apple',
                            width: double.infinity,
                            isOutlined: true,
                            icon: Icons.apple,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Register Link
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppConstants.invitationRoute);
                      },
                      child: Text(
                        'Don\'t have an account? Get Invited',
                        style: AppTextStyles.buttonMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loginWithBiometric(BuildContext context) {
    context.read<AuthBloc>().add(BiometricLoginRequested());
  }

  void _loginWithOAuth(BuildContext context, String provider) {
    context.read<AuthBloc>().add(OAuthLoginRequested(provider: provider));
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
