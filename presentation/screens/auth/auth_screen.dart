import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/core/constants/app_constants.dart';
import 'package:prueba/core/di/injection_container.dart';
import 'package:prueba/core/theme/app_colors.dart';
import 'package:prueba/core/theme/app_text_styles.dart';
import 'package:prueba/presentation/bloc/auth/auth_bloc.dart';
import 'package:prueba/presentation/widgets/common/crypto_bank_button.dart';
import 'package:prueba/presentation/widgets/common/crypto_bank_loading.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- CAMBIO: No es necesario un BlocProvider aquí si ya se provee en el router o más arriba.
    // Vamos a asumir que el AuthBloc global ya está disponible.
    return const AuthView();
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

  // --- CAMBIO: Añadimos controladores para el formulario de login y un estado para mostrarlo/ocultarlo
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showEmailForm = false;

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
    // Lógica para verificar si la biometría está disponible
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- CAMBIO: Nueva función para enviar el formulario de login
  void _submitLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(LoginWithEmailPasswordRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ));
    }
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
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppConstants.homeRoute, (route) => false);
              } else if (state is AuthError) {
                _showErrorSnackBar(context, state.message);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  // --- CAMBIO: Usamos un AnimatedSwitcher para alternar entre las opciones de login y el formulario de email
                  child: _showEmailForm
                      ? _buildEmailLoginForm()
                      : _buildLoginOptions(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- CAMBIO: Widget extraído para las opciones de login (biometría, OAuth, etc.)
  Widget _buildLoginOptions() {
    return Column(
      key: const ValueKey('LoginOptions'), // Clave para el AnimatedSwitcher
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
              const Text('Welcome Back', style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(
                'Sign in to access your CryptoBank account',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              CryptoBankButton(
                onPressed: () => setState(() => _showEmailForm = true),
                text: 'Sign In with Email',
                width: double.infinity,
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(child: Divider(color: AppColors.textHint)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Or', style: AppTextStyles.bodySmall),
                  ),
                  Expanded(child: Divider(color: AppColors.textHint)),
                ],
              ),
              const SizedBox(height: 24),
              CryptoBankButton(
                onPressed: () => _loginWithBiometric(context),
                text: 'Sign In with Biometric',
                width: double.infinity,
                isOutlined: true,
                icon: Icons.fingerprint,
              ),
            ],
          )
        ),
        const SizedBox(height: 40),
        FadeTransition(
          opacity: _fadeAnimation,
          child: TextButton(
            onPressed: () => Navigator.of(context).pushNamed(AppConstants.invitationRoute),
            child: Text(
              "Don't have an account? Register",
              style: AppTextStyles.buttonMedium.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }

  // --- CAMBIO: Nuevo widget para el formulario de login con email
  Widget _buildEmailLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('EmailForm'), // Clave para el AnimatedSwitcher
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => setState(() => _showEmailForm = false),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          const Text('Sign In', style: AppTextStyles.h2, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            'Enter your credentials to continue',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return CryptoBankButton(
                onPressed: state is AuthLoading ? null : _submitLogin,
                text: 'Sign In',
                isLoading: state is AuthLoading,
              );
            },
          ),
        ],
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