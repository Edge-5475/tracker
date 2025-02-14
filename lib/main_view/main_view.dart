import 'package:flutter/material.dart';
import 'package:tracker/add_expense/add_expense.dart';
import 'package:tracker/home/dashboard.dart';
import 'package:tracker/scan/scan_view.dart';
import 'package:tracker/report/report.dart';



class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}

  @override
  Widget build(BuildContext context) {

    Widget currentView;
    switch (_selectedIndex) {
      case 0:
        currentView = const HomeView();
        break;
      case 1:
        currentView = const AddExpensesView();
        break;
      case 2:
        currentView = const ScanView();  // Add this case
        break;
      case 3:
        currentView = const ReportView(); // Add this case
        break;
      default:
        currentView = const HomeView();
  }

    return Scaffold(
    
    backgroundColor: const Color.fromARGB(255, 41, 41, 41),
    body: currentView,
    bottomNavigationBar: Container(
      margin: EdgeInsets.all(10), // Add margin to create space from edges
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25), // Add rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect( // Wrap with ClipRRect to apply rounded corners to the navigation bar
        borderRadius: BorderRadius.circular(25),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,  // Add this line
          onTap: _onItemTapped,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.red.shade400,
          unselectedItemColor: Colors.blue.shade300,
          selectedLabelStyle: TextStyle(
            shadows: [
              Shadow(
                color: Colors.red.shade400,
                blurRadius: 10,
              ),
            ],
          ),
          unselectedLabelStyle: TextStyle(
            shadows: [
              Shadow(
                color: Colors.blue.shade300,
                blurRadius: 10,
              ),
            ],
          ),
          iconSize: 30,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Icon(
                  Icons.dashboard,
                  shadows: [
                    Shadow(
                      color: Colors.blue.shade300,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Icon(
                  Icons.money,
                  shadows: [
                    Shadow(
                      color: Colors.blue.shade300,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              label: 'Add Expenses',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Icon(
                  Icons.camera,
                  shadows: [
                    Shadow(
                      color: Colors.blue.shade300,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Icon(
                  Icons.bar_chart,
                  shadows: [
                    Shadow(
                      color: Colors.blue.shade300,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              label: 'Reports',
            ),
            
          ],
        ),
      ),
    ),
  );
  }
}