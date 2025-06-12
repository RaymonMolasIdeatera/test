import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String senderAddress;
  final String recipientAddress;
  final double amount;
  final String transactionType;
  final String status;
  final String? description;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  const Transaction({
    required this.id,
    required this.senderAddress,
    required this.recipientAddress,
    required this.amount,
    required this.transactionType,
    required this.status,
    this.description,
    required this.createdAt,
    required this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    senderAddress,
    recipientAddress,
    amount,
    transactionType,
    status,
    description,
    createdAt,
    metadata,
  ];

  bool get isIncoming =>
      transactionType == 'receive' ||
      transactionType == 'bonus' ||
      transactionType == 'referral_reward';
  bool get isOutgoing => transactionType == 'transfer';
}
