import 'package:flutter/material.dart';
import 'package:sunite/screens/home/home_screen.dart';
import 'package:sunite/screens/my_groups/my_groups_screen.dart';
import 'package:sunite/screens/profile/profile_screen.dart';

// The three main tabs and the bottom navigation bar
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Used by the bottom bar and by screens that switch tabs (Browse boards)
  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // One screen per tab, in the same order as the destinations below.
    // Built here (not const) so screens can get callbacks like _selectTab.
    final List<Widget> screens = [
      const HomeScreen(),
      MyGroupsScreen(onBrowseBoards: () => _selectTab(0)),
      const ProfileScreen(),
    ];

    return Scaffold(
      // IndexedStack shows one screen but keeps the others alive,
      // so a tab keeps its state when you switch away and back
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'My Groups',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
