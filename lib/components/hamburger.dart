import 'package:flutter/material.dart';

Widget buildHamburgerDrawer(BuildContext context) {
  void onItemTap(String title) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title clicked 💡'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }

  return Drawer(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
    ),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade100, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 800),
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.favorite, color: Colors.lightBlueAccent, size: 32),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Welcome!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          ..._buildAnimatedListTiles(onItemTap),
        ],
      ),
    ),
  );
}

List<Widget> _buildAnimatedListTiles(Function(String) onItemTap) {
  final List<Map<String, dynamic>> items = [
    {'icon': Icons.person, 'title': 'Profile'},
    {'icon': Icons.home, 'title': 'Home'},
    {'icon': Icons.list, 'title': 'Category Todos'},
    {'icon': Icons.calendar_today, 'title': 'Calendar'},
    {'icon': Icons.alarm, 'title': 'Reminders'},
    {'icon': Icons.settings, 'title': 'Settings'},
  ];

  return List.generate(items.length, (index) {
    final item = items[index];

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + index * 100),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(-30 + (30 * value), 0),
            child: InkWell(
              onTap: () => onItemTap(item['title']),
              borderRadius: BorderRadius.circular(15),
              child: ListTile(
                leading: Icon(item['icon'], color: Colors.deepPurple),
                title: Text(
                  item['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent),
              ),
            ),
          ),
        );
      },
    );
  });
}
