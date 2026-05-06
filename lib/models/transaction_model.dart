// lib/models/transaction_model.dart (নতুন ফাইল)
class TransactionModel {
  final String id;
  final String title;
  final String note;
  final double amount;
  final DateTime date;
  final TransactionType type; // income বা expense

  TransactionModel({
    required this.id,
    required this.title,
    required this.note,
    required this.amount,
    required this.date,
    required this.type,
  });
}

enum TransactionType {
  income,
  expense,
}