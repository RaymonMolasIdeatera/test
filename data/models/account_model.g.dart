// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
  id: json['id'] as String,
  address: json['address'] as String,
  clientId: json['clientId'] as String?,
  balance: (json['balance'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastActivity: DateTime.parse(json['lastActivity'] as String),
  isActive: json['isActive'] as bool,
  accountType: json['accountType'] as String,
  metadata: json['metadata'] as Map<String, dynamic>,
);

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'clientId': instance.clientId,
      'balance': instance.balance,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastActivity': instance.lastActivity.toIso8601String(),
      'isActive': instance.isActive,
      'accountType': instance.accountType,
      'metadata': instance.metadata,
    };
