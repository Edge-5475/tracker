import 'package:flutter/material.dart';
import '../add_expense/expense_model.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade300,
          child: Text(
            expense.category[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          expense.description,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Category: ${expense.category}',
          style: TextStyle(color: Colors.blue.shade300),
        ),
        trailing: Text(
          '\$${expense.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}