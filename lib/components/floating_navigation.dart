import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  CustomBottomNavBarState createState() => CustomBottomNavBarState();
}

class CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation here
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withAlpha(25), // 10% opacity
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25), // 10% opacity
            spreadRadius: 5,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white.withAlpha(230), // 90% opacity
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black45,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 20,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: AnimatedScale(
              scale: _selectedIndex == 0 ? 1.3 : 1.0,
              duration: Duration(milliseconds: 200),
              child: Transform.translate(
                offset: Offset(-20, 0),
                child: Icon(Icons.calendar_today),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _selectedIndex == 1 ? Colors.blueAccent : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withAlpha(
                        _selectedIndex == 1 ? 128 : 77), // 50% or 30%
                    spreadRadius: 4,
                    blurRadius: 12,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: AnimatedScale(
                scale: _selectedIndex == 1 ? 1.3 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: _selectedIndex == 1 ? Colors.white : Colors.blueAccent,
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AnimatedScale(
              scale: _selectedIndex == 2 ? 1.3 : 1.0,
              duration: Duration(milliseconds: 200),
              child: Transform.translate(
                offset: Offset(20, 0),
                child: Icon(Icons.notifications),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
