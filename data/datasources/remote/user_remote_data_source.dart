import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/user_model.dart';
import '../../models/transaction_model.dart';
import '../../models/affiliate_network_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile({
    String? name,
    String? username,
    String? phone,
    String? avatarUrl,
  });
  Future<double> getUserBalance();
  Future<List<TransactionModel>> getRecentTransactions();
  Future<List<AffiliateNetworkModel>> getAffiliateNetwork();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient supabaseClient;

  UserRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw AuthenticationException('User not authenticated');
      }

      final userData =
          await supabaseClient
              .from(ApiConstants.clientsTable)
              .select()
              .eq('id', user.id)
              .single();

      return UserModel.fromSupabase(userData);
    } catch (e) {
      throw ServerException('Failed to get user profile: $e');
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    String? name,
    String? username,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw AuthenticationException('User not authenticated');
      }

      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (username != null) updateData['username'] = username;
      if (phone != null) updateData['phone'] = phone;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;

      updateData['updated_at'] = DateTime.now().toIso8601String();

      final userData =
          await supabaseClient
              .from(ApiConstants.clientsTable)
              .update(updateData)
              .eq('id', user.id)
              .select()
              .single();

      return UserModel.fromSupabase(userData);
    } catch (e) {
      throw ServerException('Failed to update user profile: $e');
    }
  }

  @override
  Future<double> getUserBalance() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw AuthenticationException('User not authenticated');
      }

      final result = await supabaseClient.rpc(
        ApiConstants.getUserBalanceFunction,
        params: {'user_id': user.id},
      );

      return (result as num?)?.toDouble() ?? 0.0;
    } catch (e) {
      throw ServerException('Failed to get user balance: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw AuthenticationException('User not authenticated');
      }

      // Get user's wallet address first
      final userAccount =
          await supabaseClient
              .from(ApiConstants.accountsTable)
              .select('address')
              .eq('client_id', user.id)
              .eq('account_type', 'main')
              .single();

      final walletAddress = userAccount['address'] as String;

      // Get recent transactions
      final transactions = await supabaseClient
          .from(ApiConstants.transactionsTable)
          .select()
          .or(
            'sender_address.eq.$walletAddress,recipient_address.eq.$walletAddress',
          )
          .order('created_at', ascending: false)
          .limit(10);

      return transactions.map((t) => TransactionModel.fromSupabase(t)).toList();
    } catch (e) {
      throw ServerException('Failed to get recent transactions: $e');
    }
  }

  @override
  Future<List<AffiliateNetworkModel>> getAffiliateNetwork() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw AuthenticationException('User not authenticated');
      }

      final result = await supabaseClient.rpc(
        ApiConstants.getAffiliateNetworkFunction,
        params: {'user_id': user.id},
      );

      if (result == null) return [];

      return (result as List)
          .map((item) => AffiliateNetworkModel.fromSupabase(item))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get affiliate network: $e');
    }
  }
}
