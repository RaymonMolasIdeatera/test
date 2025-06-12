import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/entities/affiliate_network.dart';
import '../../../domain/usecases/user/get_user_profile.dart';
import '../../../domain/usecases/user/update_user_profile.dart';
import '../../../domain/usecases/user/get_user_balance.dart';
import '../../../domain/usecases/user/get_affiliate_network.dart';
import '../../../domain/usecases/usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final GetUserBalance getUserBalance;
  final GetAffiliateNetwork getAffiliateNetwork;

  UserBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.getUserBalance,
    required this.getAffiliateNetwork,
  }) : super(UserInitial()) {
    on<UserProfileRequested>(_onUserProfileRequested);
    on<UserBalanceRequested>(_onUserBalanceRequested);
    on<UserAffiliateNetworkRequested>(_onUserAffiliateNetworkRequested);
    on<UserProfileUpdateRequested>(_onUserProfileUpdateRequested);
    on<UserDataRefreshRequested>(_onUserDataRefreshRequested);
  }

  Future<void> _onUserProfileRequested(
    UserProfileRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    final result = await getUserProfile(NoParams());

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (user) => emit(UserLoaded(user: user)),
    );
  }

  Future<void> _onUserBalanceRequested(
    UserBalanceRequested event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      emit(currentState.copyWith(isBalanceLoading: true));
    }

    final result = await getUserBalance(NoParams());

    result.fold(
      (failure) {
        if (state is UserLoaded) {
          final currentState = state as UserLoaded;
          emit(
            currentState.copyWith(
              isBalanceLoading: false,
              balanceError: failure.message,
            ),
          );
        }
      },
      (balance) {
        if (state is UserLoaded) {
          final currentState = state as UserLoaded;
          emit(
            currentState.copyWith(
              balance: balance,
              isBalanceLoading: false,
              balanceError: null,
            ),
          );
        }
      },
    );
  }

  Future<void> _onUserAffiliateNetworkRequested(
    UserAffiliateNetworkRequested event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      emit(currentState.copyWith(isNetworkLoading: true));
    }

    final result = await getAffiliateNetwork(NoParams());

    result.fold(
      (failure) {
        if (state is UserLoaded) {
          final currentState = state as UserLoaded;
          emit(
            currentState.copyWith(
              isNetworkLoading: false,
              networkError: failure.message,
            ),
          );
        }
      },
      (network) {
        if (state is UserLoaded) {
          final currentState = state as UserLoaded;
          emit(
            currentState.copyWith(
              affiliateNetwork: network,
              isNetworkLoading: false,
              networkError: null,
            ),
          );
        }
      },
    );
  }

  Future<void> _onUserProfileUpdateRequested(
    UserProfileUpdateRequested event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      emit(currentState.copyWith(isUpdating: true));
    }

    final result = await updateUserProfile(
      UpdateProfileParams(
        name: event.name,
        username: event.username,
        phone: event.phone,
        avatarUrl: event.avatarUrl,
      ),
    );

    result.fold(
      (failure) {
        if (state is UserLoaded) {
          final currentState = state as UserLoaded;
          emit(
            currentState.copyWith(
              isUpdating: false,
              updateError: failure.message,
            ),
          );
        }
      },
      (user) {
        if (state is UserLoaded) {
          final currentState = state as UserLoaded;
          emit(
            currentState.copyWith(
              user: user,
              isUpdating: false,
              updateError: null,
            ),
          );
        }
      },
    );
  }

  Future<void> _onUserDataRefreshRequested(
    UserDataRefreshRequested event,
    Emitter<UserState> emit,
  ) async {
    // Refresh all user data
    add(UserProfileRequested());
    add(UserBalanceRequested());
    add(UserAffiliateNetworkRequested());
  }
}
