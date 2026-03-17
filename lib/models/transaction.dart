import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String note;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final bool isExpense;

  Transaction({
    String? id,
    required this.amount,
    required this.category,
    this.note = '',
    required this.date,
    required this.isExpense,
  }) : id = id ?? const Uuid().v4();

  Transaction copyWith({
    double? amount,
    String? category,
    String? note,
    DateTime? date,
    bool? isExpense,
  }) {
    return Transaction(
      id: id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      date: date ?? this.date,
      isExpense: isExpense ?? this.isExpense,
    );
  }
}
