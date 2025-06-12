import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.senderAddress,
    required super.recipientAddress,
    required super.amount,
    required super.transactionType,
    required super.status,
    super.description,
    required super.createdAt,
    required super.metadata,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  factory TransactionModel.fromSupabase(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      senderAddress: json['sender_address'] as String,
      recipientAddress: json['recipient_address'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionType: json['transaction_type'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'sender_address': senderAddress,
      'recipient_address': recipientAddress,
      'amount': amount,
      'transaction_type': transactionType,
      'status': status,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}
