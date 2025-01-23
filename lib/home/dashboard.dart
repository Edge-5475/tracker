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
      // Add AppBar with title
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: SafeArea(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade300,
                  shadows: [
                    Shadow(
                      color: Colors.blue.shade300,
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // Body with FutureBuilder to display expenses
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
            return const Center(
              child: Text(
                'No expenses found', 
                style: TextStyle(color: Colors.white)
              )
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final expense = Expense.fromMap(snapshot.data![index]);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.black,
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        _getCategoryIcon(expense.category),
                        color: Colors.blue.shade300,
                      ),
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

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return 'assets/icons/food.png';
      case 'transportation':
        return 'assets/icons/logistic.png';
      case 'shopping':
        return 'assets/icons/cart.png';
      case 'entertainment':
        return 'assets/icons/smartphone.png';
      case 'bills':
        return 'assets/icons/bill.png';
      case 'healthcare':
        return 'assets/icons/healthcare.png';
      default:
        return 'assets/icons/more.png';
    }
  }
}