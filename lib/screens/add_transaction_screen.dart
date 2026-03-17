import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  bool _isExpense = true;
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food';

  final List<String> _categories = [
    'Makanan',
    'Transportasi',
    'Tagihan',
    'Belanja',
    'Hiburan',
    'Gaji',
    'Lainnya'
  ];

  // Mapping Indonesian categories back to English for logic if needed, 
  // but let's just use the Indonesian ones for simplicity in this demo.
  // Actually, better to keep internal names consistent. 
  // Let's just translate the DISPLAY names.
  
  final Map<String, String> _displayCategories = {
    'Food': 'Makanan',
    'Transport': 'Transportasi',
    'Bills': 'Tagihan',
    'Shopping': 'Belanja',
    'Entertainment': 'Hiburan',
    'Salary': 'Gaji',
    'Others': 'Lainnya',
  };

  final List<String> _internalCategories = [
    'Food',
    'Transport',
    'Bills',
    'Shopping',
    'Entertainment',
    'Salary',
    'Others'
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitData() {
    final amountText = _amountController.text;
    final note = _noteController.text;

    if (amountText.isEmpty) return;

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;

    final newTransaction = Transaction(
      amount: amount,
      category: _selectedCategory,
      note: note,
      date: _selectedDate,
      isExpense: _isExpense,
    );

    ref.read(transactionProvider.notifier).addTransaction(newTransaction);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Pengeluaran'),
                    selected: _isExpense,
                    onSelected: (val) {
                      setState(() {
                        _isExpense = true;
                        if (_selectedCategory == 'Salary') _selectedCategory = 'Food';
                      });
                    },
                    selectedColor: Colors.red[100],
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text('Pemasukan'),
                    selected: !_isExpense,
                    onSelected: (val) {
                      setState(() {
                        _isExpense = false;
                        _selectedCategory = 'Salary';
                      });
                    },
                    selectedColor: Colors.green[100],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _internalCategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(_displayCategories[category] ?? category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              // Amount Field
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Nominal (Rp)',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              // Note Field
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Date Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tanggal: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text('Pilih Tanggal', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Submit Button
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Simpan Transaksi', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
