import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

class TransactionNotifier extends Notifier<List<Transaction>> {
  @override
  List<Transaction> build() {
    final dbService = ref.watch(databaseServiceProvider);
    try {
      return dbService.getTransactions();
    } catch(e) {
      return [];
    }
  }

  Future<void> addTransaction(Transaction tx) async {
    final dbService = ref.read(databaseServiceProvider);
    await dbService.addTransaction(tx);
    state = dbService.getTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    final dbService = ref.read(databaseServiceProvider);
    await dbService.deleteTransaction(id);
    state = dbService.getTransactions();
  }
}

final transactionProvider = NotifierProvider<TransactionNotifier, List<Transaction>>(() {
  return TransactionNotifier();
});

// Derived Providers
final totalBalanceProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionProvider);
  return transactions.fold(0.0, (sum, tx) => tx.isExpense ? sum - tx.amount : sum + tx.amount);
});

final totalIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionProvider);
  return transactions.where((tx) => !tx.isExpense).fold(0.0, (sum, tx) => sum + tx.amount);
});

final totalExpenseProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionProvider);
  return transactions.where((tx) => tx.isExpense).fold(0.0, (sum, tx) => sum + tx.amount);
});

// Provides aggregated expense data per category for the chart.
final expenseCategoryChartProvider = Provider<Map<String, double>>((ref) {
  final transactions = ref.watch(transactionProvider);
  final expenses = transactions.where((tx) => tx.isExpense);
  
  final Map<String, double> data = {};
  for (var expense in expenses) {
    if (data.containsKey(expense.category)) {
      data[expense.category] = (data[expense.category] ?? 0.0) + expense.amount;
    } else {
      data[expense.category] = expense.amount;
    }
  }
  return data;
});
