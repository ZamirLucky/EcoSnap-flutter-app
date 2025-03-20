import 'package:ecosnap/navigation_menu.dart';
import 'package:ecosnap/widgets/home_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Define the content for each page.
  final List<Widget> _widgetOptions = [
    const Center(child: HomeWidget()),
    // Other pages will be added here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoSnap'),
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: NavigationMenu(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}