// Add these imports at the top
import 'package:flutter/material.dart';
import '../add_expense/database_helper.dart';

class AddExpenseView extends StatefulWidget {
  const AddExpenseView({Key? key}) : super(key: key);

  @override
  _AddExpenseViewState createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  final dbHelper = DatabaseHelper.instance;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      try {
        final row = {
          DatabaseHelper.columnAmount: double.parse(_amountController.text),
          DatabaseHelper.columnDescription: _descriptionController.text,
          DatabaseHelper.columnCategory: _selectedCategory,
          DatabaseHelper.columnDate: _selectedDate.toIso8601String(),
        };

        await dbHelper.insert(row);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Expense saved successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }

        _amountController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedCategory = 'Food';
          _selectedDate = DateTime.now();
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error saving expense!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}