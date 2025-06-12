import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../widgets/dashboard/balance_card.dart';
import '../../../widgets/dashboard/quick_actions.dart';
import '../../../widgets/dashboard/recent_activity.dart';
import '../../../widgets/dashboard/stats_overview.dart';
import '../../../widgets/common/crypto_bank_loading.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

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
                Icon(Icons.error_outline, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                Text('Something went wrong', style: AppTextStyles.h4),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<UserBloc>().add(UserDataRefreshRequested());
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (state is UserLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<UserBloc>().add(UserDataRefreshRequested());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Card
                  BalanceCard(
                    balance: state.balance ?? 0.0,
                    isLoading: state.isBalanceLoading,
                    error: state.balanceError,
                  ),

                  const SizedBox(height: 24),

                  // Quick Actions
                  const QuickActions(),

                  const SizedBox(height: 24),

                  // Stats Overview
                  StatsOverview(
                    affiliateNetwork: state.affiliateNetwork ?? [],
                    isLoading: state.isNetworkLoading,
                  ),

                  const SizedBox(height: 24),

                  // Recent Activity
                  const RecentActivity(),

                  // Extra space for floating action button
                  const SizedBox(height: 80),
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
