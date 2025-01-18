import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'expense_model.dart';

// ... (keep your existing imports)

class _AddExpensesViewState extends State<AddExpensesView> {
  // ... (keep your existing variables and methods)

  // Add this method to save expense to database
  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      try {
        final expense = Expense(
          amount: double.parse(_amountController.text),
          description: _descriptionController.text,
          category: _selectedCategory,
          date: _selectedDate.toIso8601String(),
        );

        await DatabaseHelper.instance.insert(expense.toMap());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Expense Added Successfully!'),
              backgroundColor: Colors.blue.shade300,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }

        // Clear the form
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

  // Update your build method's ElevatedButton onPressed to use _saveExpense
  // Replace the existing onPressed with this:
  onPressed: _saveExpense,
}