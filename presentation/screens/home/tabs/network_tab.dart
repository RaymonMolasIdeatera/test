import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../widgets/common/crypto_bank_loading.dart';
import '../../../widgets/network/network_overview.dart';
import '../../../widgets/network/referral_list.dart';

class NetworkTab extends StatelessWidget {
  const NetworkTab({super.key});

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
                  Icons.group_outlined,
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: 16),
                Text('Network Unavailable', style: AppTextStyles.h4),
                const SizedBox(height: 8),
                Text(
                  'Unable to load network information',
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
              context.read<UserBloc>().add(UserAffiliateNetworkRequested());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Network Overview
                  NetworkOverview(
                    user: state.user,
                    affiliateNetwork: state.affiliateNetwork ?? [],
                    isLoading: state.isNetworkLoading,
                  ),

                  const SizedBox(height: 24),

                  // Referral List
                  ReferralList(
                    affiliateNetwork: state.affiliateNetwork ?? [],
                    isLoading: state.isNetworkLoading,
                  ),
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
