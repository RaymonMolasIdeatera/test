import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection_container.dart';
import '../../bloc/invitation/invitation_bloc.dart';
import '../../widgets/common/crypto_bank_button.dart';
import '../../widgets/common/crypto_bank_loading.dart';

class InvitationScreen extends StatelessWidget {
  const InvitationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InvitationBloc>(),
      child: const InvitationView(),
    );
  }
}

class InvitationView extends StatefulWidget {
  const InvitationView({super.key});

  @override
  State<InvitationView> createState() => _InvitationViewState();
}

class _InvitationViewState extends State<InvitationView>
    with TickerProviderStateMixin {
  final TextEditingController _invitationController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
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

  @override
  void dispose() {
    _invitationController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: BlocListener<InvitationBloc, InvitationState>(
            listener: (context, state) {
              if (state is InvitationValid) {
                Navigator.of(context).pushReplacementNamed(
                  AppConstants.registerRoute,
                  arguments: {'invitationCode': state.invitationCode},
                );
              } else if (state is InvitationError) {
                _showErrorSnackBar(context, state.message);
                _shakeForm();
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
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primaryTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primaryTeal.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.vpn_key,
                            size: 40,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Enter Invitation Code',
                          style: AppTextStyles.h2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'You need an invitation code from an existing member to join CryptoBank',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Invitation Input
                  SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invitation Code',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primaryTeal,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryTeal.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _invitationController,
                            focusNode: _focusNode,
                            style: AppTextStyles.bodyLarge,
                            decoration: InputDecoration(
                              hintText:
                                  '0x1234567890123456789012345678901234567890',
                              hintStyle: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textHint,
                              ),
                              prefixIcon: const Icon(
                                Icons.wallet,
                                color: AppColors.primaryTeal,
                              ),
                              filled: true,
                              fillColor: AppColors.surfaceColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.primaryTeal,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              context.read<InvitationBloc>().add(
                                InvitationCodeChanged(),
                              );
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(42),
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9a-fA-FxX]'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter the wallet address of your inviter',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Continue Button
                  BlocBuilder<InvitationBloc, InvitationState>(
                    builder: (context, state) {
                      return CryptoBankButton(
                        onPressed:
                            state is InvitationValidating
                                ? null
                                : () => _submitInvitation(context),
                        text: state is InvitationValidating ? '' : 'Continue',
                        width: double.infinity,
                        child:
                            state is InvitationValidating
                                ? const CryptoBankLoading(size: 20)
                                : null,
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Help Text
                  TextButton(
                    onPressed: () => _showHelpDialog(context),
                    child: Text(
                      'Don\'t have an invitation code?',
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: AppColors.textSecondary,
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

  void _submitInvitation(BuildContext context) {
    final invitationCode = _invitationController.text.trim();

    if (invitationCode.isEmpty) {
      _showErrorSnackBar(context, 'Please enter an invitation code');
      return;
    }

    if (!_isValidWalletAddress(invitationCode)) {
      _showErrorSnackBar(context, 'Invalid wallet address format');
      return;
    }

    context.read<InvitationBloc>().add(
      InvitationCodeSubmitted(invitationCode: invitationCode),
    );
  }

  bool _isValidWalletAddress(String address) {
    return RegExp(r'^0x[a-fA-F0-9]{40}$').hasMatch(address);
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

  void _shakeForm() {
    HapticFeedback.heavyImpact();
    // Add shake animation if needed
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Need an Invitation?', style: AppTextStyles.h4),
            content: Text(
              'CryptoBank is an invitation-only platform. You need an invitation code from an existing member to join.\n\nContact someone you know who is already using CryptoBank, or follow our social media for special invitation events.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Got it',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
