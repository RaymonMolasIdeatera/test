import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TRANSACTION HISTORY',
              style: AppTextStyles.overline.copyWith(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to full transaction history
              },
              child: Text(
                'View All',
                style: AppTextStyles.buttonSmall.copyWith(
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Sample transactions
        _TransactionItem(
          title: 'Welcome Bonus',
          subtitle: 'Registration reward',
          amount: '+100.00 CBNK',
          date: DateTime.now(),
          type: TransactionType.bonus,
        ),
        _TransactionItem(
          title: 'Referral Bonus',
          subtitle: 'Friend invitation reward',
          amount: '+50.00 CBNK',
          date: DateTime.now().subtract(const Duration(days: 1)),
          type: TransactionType.referral,
        ),
        _TransactionItem(
          title: 'Account Setup',
          subtitle: 'Initial account creation',
          amount: '+0.00 CBNK',
          date: DateTime.now().subtract(const Duration(days: 2)),
          type: TransactionType.system,
        ),
      ],
    );
  }
}

enum TransactionType { bonus, referral, send, receive, system }

class _TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final DateTime date;
  final TransactionType type;

  const _TransactionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.type,
  });

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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getTypeColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_getTypeIcon(), color: _getTypeColor(), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _getAmountColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatDate(date),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTypeColor() {
    switch (type) {
      case TransactionType.bonus:
        return AppColors.success;
      case TransactionType.referral:
        return AppColors.primaryTeal;
      case TransactionType.send:
        return AppColors.error;
      case TransactionType.receive:
        return AppColors.success;
      case TransactionType.system:
        return AppColors.info;
    }
  }

  IconData _getTypeIcon() {
    switch (type) {
      case TransactionType.bonus:
        return Icons.celebration;
      case TransactionType.referral:
        return Icons.group_add;
      case TransactionType.send:
        return Icons.send;
      case TransactionType.receive:
        return Icons.call_received;
      case TransactionType.system:
        return Icons.settings;
    }
  }

  Color _getAmountColor() {
    if (amount.startsWith('+')) {
      return AppColors.success;
    } else if (amount.startsWith('-')) {
      return AppColors.error;
    } else {
      return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
