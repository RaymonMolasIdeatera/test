import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/affiliate_network.dart';

part 'affiliate_network_model.g.dart';

@JsonSerializable()
class AffiliateNetworkModel extends AffiliateNetwork {
  const AffiliateNetworkModel({
    required super.id,
    required super.name,
    required super.username,
    required super.walletAddress,
    required super.level,
    required super.createdAt,
    required super.status,
  });

  factory AffiliateNetworkModel.fromJson(Map<String, dynamic> json) =>
      _$AffiliateNetworkModelFromJson(json);

  Map<String, dynamic> toJson() => _$AffiliateNetworkModelToJson(this);

  factory AffiliateNetworkModel.fromSupabase(Map<String, dynamic> json) {
    return AffiliateNetworkModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      walletAddress: json['wallet_address'] as String,
      level: json['level'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String,
    );
  }
}
