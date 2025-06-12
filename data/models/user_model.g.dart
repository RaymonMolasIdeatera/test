// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  walletAddress: json['walletAddress'] as String,
  email: json['email'] as String?,
  name: json['name'] as String?,
  username: json['username'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  inviterWalletAddress: json['inviterWalletAddress'] as String?,
  isActive: json['isActive'] as bool,
  tier: json['tier'] as String,
  metadata: json['metadata'] as Map<String, dynamic>,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'walletAddress': instance.walletAddress,
  'email': instance.email,
  'name': instance.name,
  'username': instance.username,
  'phone': instance.phone,
  'avatarUrl': instance.avatarUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'inviterWalletAddress': instance.inviterWalletAddress,
  'isActive': instance.isActive,
  'tier': instance.tier,
  'metadata': instance.metadata,
};
