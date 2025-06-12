import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/account.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel extends Account {
  const AccountModel({
    required super.id,
    required super.address,
    super.clientId,
    required super.balance,
    required super.createdAt,
    required super.lastActivity,
    required super.isActive,
    required super.accountType,
    required super.metadata,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);

  factory AccountModel.fromSupabase(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String,
      address: json['address'] as String,
      clientId: json['client_id'] as String?,
      balance: (json['balance'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActivity: DateTime.parse(json['last_activity'] as String),
      isActive: json['is_active'] as bool,
      accountType: json['account_type'] as String,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'address': address,
      'client_id': clientId,
      'balance': balance,
      'created_at': createdAt.toIso8601String(),
      'last_activity': lastActivity.toIso8601String(),
      'is_active': isActive,
      'account_type': accountType,
      'metadata': metadata,
    };
  }
}
