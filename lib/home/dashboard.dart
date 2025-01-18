import 'package:flutter/material.dart';
import 'package:tracker/add_expense/expense_model.dart';
import 'package:tracker/add_expense/database_helper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 41, 41),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.queryAllRows(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No expenses found', 
              style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final expense = Expense.fromMap(snapshot.data![index]);
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
            },
          );
        },
      ),
    );
  }
}