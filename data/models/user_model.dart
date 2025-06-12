import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.walletAddress,
    super.email,
    super.name,
    super.username,
    super.phone,
    super.avatarUrl,
    required super.createdAt,
    required super.updatedAt,
    super.inviterWalletAddress,
    required super.isActive,
    required super.tier,
    required super.metadata,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromSupabase(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      walletAddress: json['wallet_address'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      inviterWalletAddress: json['inviter_wallet_address'] as String?,
      isActive: json['is_active'] as bool,
      tier: json['tier'] as String,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'wallet_address': walletAddress,
      'email': email,
      'name': name,
      'username': username,
      'phone': phone,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'inviter_wallet_address': inviterWalletAddress,
      'is_active': isActive,
      'tier': tier,
      'metadata': metadata,
    };
  }
}
