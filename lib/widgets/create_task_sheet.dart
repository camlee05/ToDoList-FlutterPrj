import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTaskSheet extends StatefulWidget {
  final List<Map<String, dynamic>> groups;
  final Function(Map<String, dynamic>) onCreateTask;

  const CreateTaskSheet({
    super.key,
    required this.groups,
    required this.onCreateTask,
  });

  @override
  State<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<CreateTaskSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  Map<String, dynamic>? selectedGroup;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
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
                    Text("Create Task",
                        style: GoogleFonts.poppins(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context))
                  ],
                ),

                const SizedBox(height: 16),

                // Task name
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Task name",
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
                    labelText: "Description (optional)",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // 🗓 Chọn ngày & giờ
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today),
                        label: Text(selectedDate == null
                            ? "Pick Date"
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickTime,
                        icon: const Icon(Icons.access_time),
                        label: Text(selectedTime == null
                            ? "Pick Time"
                            : selectedTime!.format(context)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // List selection
                Text("Select List",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.groups.map((group) {
                    final isSelected = selectedGroup == group;
                    return GestureDetector(
                      onTap: () => setState(() => selectedGroup = group),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? group['color']
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: group['color']),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: group['color'].withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ]
                              : [],
                        ),
                        child: Text(group['title'],
                            style: GoogleFonts.poppins(
                              color:
                              isSelected ? Colors.white : Colors.black87,
                            )),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 25),

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
                    ),
                    onPressed: _createTask,
                    child: const Text("Create Task",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Hàm chọn ngày
  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  // Hàm chọn giờ
  Future<void> _pickTime() async {
    final picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => selectedTime = picked);
  }

  // Tạo task mới
  void _createTask() {
    if (titleController.text.trim().isEmpty ||
        selectedGroup == null ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    // Gộp ngày & giờ thành DateTime
    final dueDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final newTask = {
      'title': titleController.text.trim(),
      'description': descController.text.trim(),
      'dueDate': dueDate,
      'category': selectedGroup!['title'],
      'color': selectedGroup!['color'],
      'status': 'todo',
      'done': false,
    };

    widget.onCreateTask(newTask);
    Navigator.pop(context);
  }
}
