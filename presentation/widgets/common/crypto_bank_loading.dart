import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CryptoBankLoading extends StatefulWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const CryptoBankLoading({
    super.key,
    this.size = 40,
    this.color,
    this.strokeWidth = 3,
  });

  @override
  State<CryptoBankLoading> createState() => _CryptoBankLoadingState();
}

class _CryptoBankLoadingState extends State<CryptoBankLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircularProgressIndicator(
        strokeWidth: widget.strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.color ?? AppColors.primaryTeal,
        ),
      ),
    );
  }
}
