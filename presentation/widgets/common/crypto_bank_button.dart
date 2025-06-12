import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

class CryptoBankButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isOutlined;
  final bool isLoading;
  final IconData? icon;

  const CryptoBankButton({
    super.key,
    this.onPressed,
    this.text,
    this.child,
    this.width,
    this.height = 48,
    this.backgroundColor,
    this.foregroundColor,
    this.isOutlined = false,
    this.isLoading = false,
    this.icon,
  });

  @override
  State<CryptoBankButton> createState() => _CryptoBankButtonState();
}

class _CryptoBankButtonState extends State<CryptoBankButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.shortAnimation,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow:
                  isEnabled
                      ? [
                        BoxShadow(
                          color: (widget.backgroundColor ??
                                  AppColors.primaryTeal)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : null,
            ),
            child:
                widget.isOutlined
                    ? OutlinedButton(
                      onPressed: isEnabled ? _handlePress : null,
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            widget.backgroundColor ?? Colors.transparent,
                        foregroundColor:
                            widget.foregroundColor ?? AppColors.primaryTeal,
                        side: BorderSide(
                          color:
                              widget.foregroundColor ?? AppColors.primaryTeal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _buildContent(),
                    )
                    : ElevatedButton(
                      onPressed: isEnabled ? _handlePress : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            widget.backgroundColor ?? AppColors.primaryTeal,
                        foregroundColor:
                            widget.foregroundColor ?? AppColors.background,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: AppColors.textHint,
                        disabledForegroundColor: AppColors.textDisabled,
                      ),
                      child: _buildContent(),
                    ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),
        ),
      );
    }

    if (widget.child != null) {
      return widget.child!;
    }

    if (widget.icon != null && widget.text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 20),
          const SizedBox(width: 8),
          Text(widget.text!, style: AppTextStyles.buttonMedium),
        ],
      );
    }

    return Text(widget.text ?? '', style: AppTextStyles.buttonMedium);
  }

  void _handlePress() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onPressed?.call();
    });
  }
}
