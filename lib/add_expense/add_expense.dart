import 'package:flutter/material.dart';


class AddExpensesView extends StatelessWidget {
  const AddExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: const Center(
        child: Text('Add Expense Form Will Go Here'),
      ),
    );
  }
}