import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../widgets/common/crypto_bank_loading.dart';
import '../../../widgets/wallet/wallet_header.dart';
import '../../../widgets/wallet/transaction_list.dart';

class WalletTab extends StatelessWidget {
  const WalletTab({super.key});

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
                  Icons.account_balance_wallet_outlined,
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: 16),
                Text('Wallet Unavailable', style: AppTextStyles.h4),
                const SizedBox(height: 8),
                Text(
                  'Unable to load wallet information',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is UserLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<UserBloc>().add(UserBalanceRequested());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wallet Header
                  WalletHeader(
                    user: state.user,
                    balance: state.balance ?? 0.0,
                    isLoading: state.isBalanceLoading,
                  ),

                  const SizedBox(height: 24),

                  // Transaction History
                  const TransactionList(),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
