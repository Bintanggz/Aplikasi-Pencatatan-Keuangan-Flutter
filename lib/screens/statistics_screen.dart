import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../widgets/expense_pie_chart.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartData = ref.watch(expenseCategoryChartProvider);
    final totalExpense = ref.watch(totalExpenseProvider);
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
      ),
      body: chartData.isEmpty
          ? const Center(child: Text('Belum ada data pengeluaran.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Total Pengeluaran', style: TextStyle(fontSize: 16, color: Colors.grey)),
                          const SizedBox(height: 8),
                          Text(
                            currencyFormat.format(totalExpense),
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Rincian Kategori', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ExpensePieChart(categoryData: chartData),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // List of category expenses
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: chartData.length,
                    itemBuilder: (context, index) {
                      final category = chartData.keys.elementAt(index);
                      final amount = chartData[category]!;
                      final percentage = (amount / totalExpense) * 100;
                      
                      return ListTile(
                        title: Text(category),
                        subtitle: LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(currencyFormat.format(amount), style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${percentage.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
    );
  }
}
