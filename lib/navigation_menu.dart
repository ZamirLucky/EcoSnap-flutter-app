import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  
  const NavigationMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25), 
        topRight: Radius.circular(25)
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Container(
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.lightGreen,
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Left side items
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: selectedIndex == 0 ? Colors.pink : Colors.grey,
                ),
                onPressed: () => onItemTapped(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: selectedIndex == 1 ? Colors.pink : Colors.grey,
                ),
                onPressed: () => onItemTapped(1),
              ),
              // Spacer for the FAB notch
              const SizedBox(width: 40),
              // Right side items
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: selectedIndex == 2 ? Colors.pink : Colors.grey,
                ),
                onPressed: () => onItemTapped(2),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: selectedIndex == 3 ? Colors.pink : Colors.grey,
                ),
                onPressed: () => onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
