import 'dart:io';
import 'package:csv/csv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/transaction.dart';

class DatabaseService {
  static const String boxName = 'transactions';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TransactionAdapter());
    await Hive.openBox<Transaction>(boxName);
    
    // Add dummy data if empty
    final box = getBox();
    if (box.isEmpty) {
      await addDummyData();
    }
  }

  Box<Transaction> getBox() {
    return Hive.box<Transaction>(boxName);
  }

  List<Transaction> getTransactions() {
    final box = getBox();
    return box.values.toList().cast<Transaction>()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addTransaction(Transaction transaction) async {
    final box = getBox();
    await box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    final box = getBox();
    await box.delete(id);
  }

  Future<void> addDummyData() async {
    final box = getBox();
    final dummyData = [
      Transaction(
        amount: 5000000,
        category: 'Salary',
        note: 'Gaji Bulanan',
        date: DateTime.now().subtract(const Duration(days: 5)),
        isExpense: false,
      ),
      Transaction(
        amount: 75000,
        category: 'Food',
        note: 'Makan Siang Bakso',
        date: DateTime.now().subtract(const Duration(days: 3)),
        isExpense: true,
      ),
      Transaction(
        amount: 150000,
        category: 'Transport',
        note: 'Isi Pertalite',
        date: DateTime.now().subtract(const Duration(days: 2)),
        isExpense: true,
      ),
      Transaction(
        amount: 1200000,
        category: 'Shopping',
        note: 'Sepatu Baru',
        date: DateTime.now().subtract(const Duration(days: 1)),
        isExpense: true,
      ),
    ];

    for (var tx in dummyData) {
      await box.put(tx.id, tx);
    }
  }

  Future<String> exportToCSV() async {
    final transactions = getTransactions();
    List<List<dynamic>> rows = [];
    
    // Header
    rows.add(["ID", "Category", "Amount", "Type", "Note", "Date"]);
    
    // Data
    for (var tx in transactions) {
      rows.add([
        tx.id,
        tx.category,
        tx.amount,
        tx.isExpense ? "Expense" : "Income",
        tx.note,
        tx.date.toIso8601String()
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/finnote_export_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);
    await file.writeAsString(csv);
    
    return path;
  }
}
