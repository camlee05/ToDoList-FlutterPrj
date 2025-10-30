import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/group_card.dart';
import '../widgets/create_group_sheet.dart';

class GroupsPage extends StatefulWidget {
  final List<Map<String, dynamic>> groups;
  final Function(Map<String, dynamic>) onAddGroup;

  const GroupsPage({
    super.key,
    required this.groups,
    required this.onAddGroup,
  });

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  void _openCreateGroupSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateGroupSheet(
        onCreateGroup: (newGroup) {
          widget.onAddGroup(newGroup);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("List",
                      style: GoogleFonts.poppins(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _openCreateGroupSheet,
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text("New List",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.groups.length,
                  itemBuilder: (context, index) {
                    final g = widget.groups[index];
                    return GroupCard(
                      title: g['title'],
                      subtitle: g['subtitle'],
                      tasks: g['tasks'],
                      color: g['color'],
                      icon: g['icon'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
