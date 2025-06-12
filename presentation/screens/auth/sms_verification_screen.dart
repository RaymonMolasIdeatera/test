import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../../bloc/registration/registration_bloc.dart';
import '../../bloc/registration/registration_event.dart'; // AGREGAR IMPORT
import '../../bloc/registration/registration_state.dart'; // AGREGAR IMPORT
import '../../widgets/common/crypto_bank_button.dart';
import '../../widgets/common/crypto_bank_loading.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SmsVerificationScreen extends StatefulWidget {
  final String phone;
  final String name;
  final String? invitationCode;
  final Map<String, dynamic>? metadata;

  // CORRECCIÓN: Usar super parameters
  const SmsVerificationScreen({
    super.key,
    required this.phone,
    required this.name,
    this.invitationCode,
    this.metadata,
  });

  @override
  State<SmsVerificationScreen> createState() => _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends State<SmsVerificationScreen> {
  final _pinController = TextEditingController();
  bool _isComplete = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Verify Phone',
          style: AppTextStyles.headingMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is RegistrationSuccess) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/home', (route) => false);
          }
        },
        builder: (context, state) {
          if (state is RegistrationLoading) {
            return const Center(child: CryptoBankLoading());
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Icono
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    // CORRECCIÓN LÍNEA 89: Usar Color en lugar de LinearGradient
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(Icons.sms, color: AppColors.primary, size: 40),
                ),
                const SizedBox(height: 32),

                // Título
                Text(
                  'Enter verification code',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Subtítulo
                Text(
                  'We sent a 6-digit code to\n${widget.phone}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // PIN Input
                Pinput(
                  controller: _pinController,
                  length: 6,
                  onCompleted: (pin) {
                    setState(() => _isComplete = true);
                  },
                  onChanged: (value) {
                    setState(() => _isComplete = value.length == 6);
                  },
                  defaultPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: AppTextStyles.headingMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: AppTextStyles.headingMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: AppTextStyles.headingMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: BoxDecoration(
                      // CORRECCIÓN LÍNEA 157: Usar withValues en lugar de withOpacity
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  child: CryptoBankButton(
                    text: 'Verify Code',
                    onPressed: _isComplete ? _verifyCode : null,
                  ),
                ),
                const SizedBox(height: 24),

                // Resend Code
                TextButton(
                  onPressed: _resendCode,
                  child: Text(
                    'Didn\'t receive the code? Resend',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const Spacer(),

                // Mensaje para MVP
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    // CORRECCIÓN LÍNEA 192: Usar withValues en lugar de withOpacity
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      // CORRECCIÓN LÍNEA 195: Usar withValues en lugar de withOpacity
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'For MVP demo, use code: 123456',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _verifyCode() {
    // CORRECCIÓN LÍNEA 227: Usar context.read().add() correctamente
    context.read<RegistrationBloc>().add(
      VerifyPhoneCodeEvent(
        phone: widget.phone,
        code: _pinController.text,
        name: widget.name,
        invitationCode: widget.invitationCode,
        metadata: widget.metadata,
      ),
    );
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code resent to ${widget.phone}'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}