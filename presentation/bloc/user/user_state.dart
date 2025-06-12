part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  final double? balance;
  final List<AffiliateNetwork>? affiliateNetwork;
  final bool isBalanceLoading;
  final bool isNetworkLoading;
  final bool isUpdating;
  final String? balanceError;
  final String? networkError;
  final String? updateError;

  const UserLoaded({
    required this.user,
    this.balance,
    this.affiliateNetwork,
    this.isBalanceLoading = false,
    this.isNetworkLoading = false,
    this.isUpdating = false,
    this.balanceError,
    this.networkError,
    this.updateError,
  });

  @override
  List<Object?> get props => [
    user,
    balance,
    affiliateNetwork,
    isBalanceLoading,
    isNetworkLoading,
    isUpdating,
    balanceError,
    networkError,
    updateError,
  ];

  UserLoaded copyWith({
    User? user,
    double? balance,
    List<AffiliateNetwork>? affiliateNetwork,
    bool? isBalanceLoading,
    bool? isNetworkLoading,
    bool? isUpdating,
    String? balanceError,
    String? networkError,
    String? updateError,
  }) {
    return UserLoaded(
      user: user ?? this.user,
      balance: balance ?? this.balance,
      affiliateNetwork: affiliateNetwork ?? this.affiliateNetwork,
      isBalanceLoading: isBalanceLoading ?? this.isBalanceLoading,
      isNetworkLoading: isNetworkLoading ?? this.isNetworkLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      balanceError: balanceError,
      networkError: networkError,
      updateError: updateError,
    );
  }
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}
