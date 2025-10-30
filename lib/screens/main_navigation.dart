import 'package:flutter/material.dart';
import 'home_page.dart';
import 'groups_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // ✅ Danh sách group dùng chung
  List<Map<String, dynamic>> groups = [
    {
      'title': 'Work',
      'subtitle': 'To Do',
      'tasks': '14/14',
      'color': const Color(0xFFF5C04E),
      'icon': Icons.work,
    },
    {
      'title': 'Family',
      'subtitle': 'In Progress',
      'tasks': '6/12',
      'color': const Color(0xFF4CAF88),
      'icon': Icons.family_restroom,
    },
  ];

  // ✅ Danh sách task dùng chung
  List<Map<String, dynamic>> tasks = [

  ];

  // ✅ Thêm task mới
  void addTask(Map<String, dynamic> newTask) {
    setState(() {
      newTask["done"] = false;
      tasks.add(newTask);
    });
  }

  // ✅ Cập nhật task (sửa)
  void updateTask(Map<String, dynamic> updatedTask) {
    setState(() {}); // vì task là tham chiếu nên chỉ cần rebuild
  }

  // ✅ Xoá task
  void deleteTask(Map<String, dynamic> task) {
    setState(() {
      tasks.remove(task);
    });
  }

  // ✅ Thêm group mới
  void addGroup(Map<String, dynamic> newGroup) {
    setState(() {
      groups.add(newGroup);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        groups: groups,
        tasks: tasks,
        onAddTask: addTask,
        onUpdateTask: updateTask,
        onDeleteTask: deleteTask,
      ),
      GroupsPage(groups: groups, onAddGroup: addGroup),
      const Placeholder(),
      const Placeholder(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "My List"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none), label: "Notifications"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: "Settings"),
        ],
      ),
    );
  }
}
