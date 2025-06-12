import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Supabase Configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get supabaseServiceKey =>
      dotenv.env['SUPABASE_SERVICE_ROLE_KEY'] ?? '';

  // Environment
  static bool get isProduction => dotenv.env['IS_PRODUCTION'] == 'true';
  static bool get isDevelopment => !isProduction;

  // API Endpoints
  static const String authEndpoint = '/auth/v1';
  static const String databaseEndpoint = '/rest/v1';
  static const String storageEndpoint = '/storage/v1';

  // Tables
  static const String clientsTable = 'clients';
  static const String accountsTable = 'accounts';
  static const String transactionsTable = 'transactions';
  static const String invitationTrackingTable = 'invitation_tracking';
  static const String affiliateMetricsTable = 'affiliate_metrics';
  static const String devicesTable = 'devices';
  static const String userSessionsTable = 'user_sessions';

  // Functions
  static const String verifyInvitationFunction = 'verify_invitation_code';
  static const String registerUserFunction = 'register_new_user';
  static const String getUserBalanceFunction = 'get_user_balance';
  static const String getAffiliateNetworkFunction = 'get_affiliate_network';
  static const String generateWalletFunction = 'generate_unique_wallet_address';
}
