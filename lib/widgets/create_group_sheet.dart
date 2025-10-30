import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateGroupSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onCreateGroup;

  const CreateGroupSheet({super.key, required this.onCreateGroup});

  @override
  State<CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<CreateGroupSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  Color selectedColor = const Color(0xFFF5C04E);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFFDFBF8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Create Group",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Group name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Group name",
                    labelStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    hintText: "Add description...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                // Color picker
                Text(
                  "Choose color",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorOption(const Color(0xFFF5C04E)),
                    _colorOption(const Color(0xFF4CAF88)),
                    _colorOption(const Color(0xFFE57373)),
                    _colorOption(const Color(0xFF3E5BA9)),
                  ],
                ),

                const SizedBox(height: 30),

                // Create button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    onPressed: _createGroup,
                    child: const Text(
                      "Create Group",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ----------------- HELPER: Chọn màu -----------------
  Widget _colorOption(Color color) {
    bool isSelected = color == selectedColor;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border:
          isSelected ? Border.all(color: Colors.black, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(2, 3),
              blurRadius: 5,
            ),
          ],
        ),
      ),
    );
  }

  // ----------------- HELPER: Tạo group mới -----------------
  void _createGroup() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a group name")),
      );
      return;
    }

    final newGroup = {
      'title': nameController.text.trim(),
      'subtitle': 'To Do',
      'tasks': descController.text.trim().isEmpty
          ? '0/0'
          : descController.text.trim(),
      'color': selectedColor,
      'icon': Icons.folder,
    };

    widget.onCreateGroup(newGroup);
  }
}
