import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tracker/add_expense/database_helper.dart';
import 'package:tracker/add_expense/expense_model.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  Map<String, double> categoryTotals = {};
  Map<String, List<Expense>> categoryExpenses = {};
  final ScrollController _scrollController = ScrollController();
  bool _showLegend = true;

  // Define category colors
  final Map<String, Color> categoryColors = {
    'Food': const Color(0xFF00E5FF),         // Cyan
    'Transportation': const Color(0xFF536DFE), // Blue
    'Shopping': const Color(0xFF7C4DFF),      // Deep Purple
    'Entertainment': const Color(0xFF1DE9B6),  // Teal
    'Bills': const Color(0xFF448AFF),         // Light Blue
    'Healthcare': const Color(0xFF40C4FF),     // Lighter Blue
    'Other': const Color(0xFF64FFDA),         // Teal Accent
  };

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadExpenses() async {
    final expenses = await DatabaseHelper.instance.queryAllRows();
    final Map<String, double> totals = {};
    final Map<String, List<Expense>> expensesByCategory = {};

    for (var expenseMap in expenses) {
      final expense = Expense.fromMap(expenseMap);
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
      expensesByCategory[expense.category] = 
        [...(expensesByCategory[expense.category] ?? []), expense];
    }

    if (mounted) {
      setState(() {
        categoryTotals = totals;
        categoryExpenses = expensesByCategory;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 50 && _showLegend) {
      setState(() {
        _showLegend = false;
      });
    } else if (_scrollController.offset <= 50 && !_showLegend) {
      setState(() {
        _showLegend = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 41, 41),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Report Heading
          Container(
            padding: const EdgeInsets.only(bottom: 20), // Removed negative top padding
            margin: const EdgeInsets.only(top: 0), // Use margin instead for positioning
            child: Text(
              'Expense Report',
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

          // Fixed Pie Chart Section with reduced size
          Container(
            height: 220,  // Reduced from 280
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade300.withOpacity(0.2),
                        blurRadius: 25,  // Reduced from 30
                        spreadRadius: 8,  // Reduced from 10
                      ),
                      BoxShadow(
                        color: Colors.blue.shade200.withOpacity(0.1),
                        blurRadius: 35,
                        spreadRadius: 15,
                      ),
                    ],
                  ),
                  child: categoryTotals.isEmpty
                      ? const Center(
                          child: Text(
                            'No expenses to show',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : PieChart(
                          PieChartData(
                            sections: categoryTotals.entries.map((entry) {
                              return PieChartSectionData(
                                color: categoryColors[entry.key]?.withOpacity(0.9),
                                value: entry.value,
                                title: '',
                                radius: 85,  // Reduced from 110
                                showTitle: false,
                                borderSide: BorderSide.none, // Remove border
                              );
                            }).toList(),
                            sectionsSpace: 1.5,
                            centerSpaceRadius: 30,  // Reduced from 40
                            startDegreeOffset: 270,
                          ),
                        ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),  // Increased spacing

          // Legend Section with background
          Container(
            height: 150, // Increased from 120 to 150
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade300.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                for (var i = 0; i < categoryTotals.length; i += 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var j = i; j < i + 3 && j < categoryTotals.length; j++)
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: categoryColors[categoryTotals.keys.elementAt(j)]?.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (categoryColors[categoryTotals.keys.elementAt(j)] ?? Colors.blue).withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${categoryTotals.keys.elementAt(j)}\n${(categoryTotals.values.elementAt(j) / categoryTotals.values.reduce((a, b) => a + b) * 100).toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      height: 1.3,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                if (j < i + 2 && j < categoryTotals.length - 1)
                                  const SizedBox(width: 8),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Category List (Existing code)
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: categoryExpenses.entries.map((entry) {
                  final category = entry.key;
                  final expenses = entry.value;
                  final total = categoryTotals[category]!;
                  
                  return ExpansionTile(
                    title: Text(
                      category,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Total: \$${total.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.blue.shade300),
                    ),
                    children: expenses.map((expense) {
                      return ListTile(
                        title: Text(
                          expense.description,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          '\$${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}