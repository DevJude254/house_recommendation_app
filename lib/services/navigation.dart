import 'package:flutter/material.dart';
import 'package:unistay/pages/about.dart';

import '../pages/home.dart';
import '../pages/predict_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  //list of widgets (pages)
  final List<Widget> _pages = [
    Home(),
    PredictPage(),
    About(),


  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show selected page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.data_exploration),
            label: "Recommend",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: "Predict",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.info),
            label: "About"
          )

        ],
      ),
    );
  }
}

