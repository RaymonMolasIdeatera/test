part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserProfileRequested extends UserEvent {}

class UserBalanceRequested extends UserEvent {}

class UserAffiliateNetworkRequested extends UserEvent {}

class UserProfileUpdateRequested extends UserEvent {
  final String? name;
  final String? username;
  final String? phone;
  final String? avatarUrl;

  const UserProfileUpdateRequested({
    this.name,
    this.username,
    this.phone,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, username, phone, avatarUrl];
}

class UserDataRefreshRequested extends UserEvent {}
