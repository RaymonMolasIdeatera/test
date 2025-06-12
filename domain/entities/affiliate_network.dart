import 'package:equatable/equatable.dart';

class AffiliateNetwork extends Equatable {
  final String id;
  final String name;
  final String username;
  final String walletAddress;
  final int level;
  final DateTime createdAt;
  final String status;

  const AffiliateNetwork({
    required this.id,
    required this.name,
    required this.username,
    required this.walletAddress,
    required this.level,
    required this.createdAt,
    required this.status,
  });

  @override
  List<Object> get props => [
    id,
    name,
    username,
    walletAddress,
    level,
    createdAt,
    status,
  ];
}
