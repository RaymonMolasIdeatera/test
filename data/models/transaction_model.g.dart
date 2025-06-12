// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      senderAddress: json['senderAddress'] as String,
      recipientAddress: json['recipientAddress'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionType: json['transactionType'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderAddress': instance.senderAddress,
      'recipientAddress': instance.recipientAddress,
      'amount': instance.amount,
      'transactionType': instance.transactionType,
      'status': instance.status,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'metadata': instance.metadata,
    };
