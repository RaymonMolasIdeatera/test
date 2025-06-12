part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AppEvent {}

class AppThemeChanged extends AppEvent {
  final bool isDarkMode;

  const AppThemeChanged({required this.isDarkMode});

  @override
  List<Object> get props => [isDarkMode];
}
