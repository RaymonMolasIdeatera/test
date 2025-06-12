// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'affiliate_network_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AffiliateNetworkModel _$AffiliateNetworkModelFromJson(
  Map<String, dynamic> json,
) => AffiliateNetworkModel(
  id: json['id'] as String,
  name: json['name'] as String,
  username: json['username'] as String,
  walletAddress: json['walletAddress'] as String,
  level: (json['level'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  status: json['status'] as String,
);

Map<String, dynamic> _$AffiliateNetworkModelToJson(
  AffiliateNetworkModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'username': instance.username,
  'walletAddress': instance.walletAddress,
  'level': instance.level,
  'createdAt': instance.createdAt.toIso8601String(),
  'status': instance.status,
};
