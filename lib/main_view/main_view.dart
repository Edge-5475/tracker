import 'package:flutter/material.dart';
import 'package:tracker/home/dashboard.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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

  @override
  Widget build(BuildContext context) {

   PageStorageBucket bucket = PageStorageBucket();
   Widget currentView = const HomeView();
   return Scaffold(
    
    backgroundColor: const Color.fromARGB(255, 41, 41, 41),
    body: PageStorage(bucket: bucket, child: currentView),
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
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Icon(
                  Icons.settings,
                  shadows: [
                    Shadow(
                      color: Colors.blue.shade300,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    ),
  );
  }
}