import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String walletAddress;
  final String? email;
  final String? name;
  final String? username;
  final String? phone;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? inviterWalletAddress;
  final bool isActive;
  final String tier;
  final Map<String, dynamic> metadata;

  const User({
    required this.id,
    required this.walletAddress,
    this.email,
    this.name,
    this.username,
    this.phone,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    this.inviterWalletAddress,
    required this.isActive,
    required this.tier,
    required this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    walletAddress,
    email,
    name,
    username,
    phone,
    avatarUrl,
    createdAt,
    updatedAt,
    inviterWalletAddress,
    isActive,
    tier,
    metadata,
  ];

  User copyWith({
    String? id,
    String? walletAddress,
    String? email,
    String? name,
    String? username,
    String? phone,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? inviterWalletAddress,
    bool? isActive,
    String? tier,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      walletAddress: walletAddress ?? this.walletAddress,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      inviterWalletAddress: inviterWalletAddress ?? this.inviterWalletAddress,
      isActive: isActive ?? this.isActive,
      tier: tier ?? this.tier,
      metadata: metadata ?? this.metadata,
    );
  }
}
