import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String id;
  final String address;
  final String? clientId;
  final double balance;
  final DateTime createdAt;
  final DateTime lastActivity;
  final bool isActive;
  final String accountType;
  final Map<String, dynamic> metadata;

  const Account({
    required this.id,
    required this.address,
    this.clientId,
    required this.balance,
    required this.createdAt,
    required this.lastActivity,
    required this.isActive,
    required this.accountType,
    required this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    address,
    clientId,
    balance,
    createdAt,
    lastActivity,
    isActive,
    accountType,
    metadata,
  ];
}
