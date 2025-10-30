import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/create_task_sheet.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> groups;
  final List<Map<String, dynamic>> tasks;
  final Function(Map<String, dynamic>) onAddTask;
  final Function(Map<String, dynamic>) onUpdateTask;
  final Function(Map<String, dynamic>) onDeleteTask;

  const HomePage({
    super.key,
    required this.groups,
    required this.tasks,
    required this.onAddTask,
    required this.onUpdateTask,
    required this.onDeleteTask,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedDateIndex = 0; // 0 = Today, 1 = Tomorrow, 2 = Next 7 Days

  @override
  Widget build(BuildContext context) {
    final todoTasks =
    widget.tasks.where((t) => t["done"] == false).toList();
    final completedTasks =
    widget.tasks.where((t) => t["done"] == true).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👋 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hey,", style: GoogleFonts.poppins(fontSize: 16)),
                          Text(
                            "Alex!",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // ➕ New Task
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _openCreateTask,
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text("New Task",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),

              const SizedBox(height: 25),

              // 📅 Date selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _dateButton("Today", 0, isToday: true),
                  _dateButton("Tomorrow", 1),
                  _dateButton("Next 7 Days", 2),
                ],
              ),

              const SizedBox(height: 25),

              // ---------------- To Do ----------------
              Text("To Do (${todoTasks.length})",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              if (todoTasks.isEmpty)
                _emptyMessage("No tasks left "),
              ...todoTasks.map((task) => _taskCard(task)),

              const SizedBox(height: 25),

              // ---------------- Completed ----------------
              Text("Completed (${completedTasks.length})",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              if (completedTasks.isEmpty)
                _emptyMessage("No completed tasks yet 😅"),
              ...completedTasks.map((task) => _taskCard(task)),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- Nút chọn ngày -------------------
  Widget _dateButton(String text, int index, {bool isToday = false}) {
    final bool selected = selectedDateIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedDateIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? Colors.blueAccent
              : isToday
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade400),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ]
              : [],
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: selected
                ? Colors.white
                : isToday
                ? Colors.black
                : Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ------------------- Mở popup tạo task -------------------
  void _openCreateTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateTaskSheet(
        groups: widget.groups,
        onCreateTask: (newTask) {
          widget.onAddTask(newTask);
          setState(() {}); // làm mới giao diện
        },
      ),
    );
  }

  // ------------------- Thẻ hiển thị Task -------------------
  Widget _taskCard(Map<String, dynamic> task) {
    bool done = task["done"] ?? false;

    return GestureDetector(
      onTap: () => _showTaskOptions(task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: task["color"],
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Nội dung bên trái
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task["title"],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationThickness: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${_formatDateTime(task["dueDate"])} • ${task["category"]}",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white.withOpacity(done ? 0.4 : 0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // 🔘 Check button
              GestureDetector(
                onTap: () {
                  setState(() {
                    task["done"] = !done;
                  });
                  widget.onUpdateTask(task);
                },
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    color: done ? Colors.white : Colors.transparent,
                  ),
                  child: done
                      ? const Icon(Icons.check, color: Colors.black, size: 16)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- Popup sửa / xoá -------------------
  void _showTaskOptions(Map<String, dynamic> task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            runSpacing: 10,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text("Task Options",
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold)),

              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text("Edit Task"),
                onTap: () {
                  Navigator.pop(context);
                  _editTask(task);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete Task"),
                onTap: () {
                  Navigator.pop(context);
                  widget.onDeleteTask(task);
                  setState(() {});
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.grey),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // ------------------- Hàm sửa Task -------------------
  void _editTask(Map<String, dynamic> oldTask) async {
    final titleController = TextEditingController(text: oldTask["title"]);
    DateTime selectedDate = oldTask["dueDate"];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(
            color: Color(0xFFFDFBF8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              runSpacing: 15,
              children: [
                Text("Edit Task",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Task name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setModalState(() => selectedDate = picked);
                    }
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  onPressed: () {
                    setState(() {
                      oldTask["title"] = titleController.text.trim();
                      oldTask["dueDate"] = selectedDate;
                    });
                    widget.onUpdateTask(oldTask);
                    Navigator.pop(context);
                  },
                  child: const Text("Save Changes",
                      style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------- Format thời gian -------------------
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "";
    final now = DateTime.now();
    final diff = dateTime.difference(now);

    String timeStr =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

    if (diff.inDays == 0) {
      if (diff.isNegative) return "Overdue • $timeStr";
      return "Today • $timeStr";
    } else if (diff.inDays == 1) {
      return "Tomorrow • $timeStr";
    } else {
      return "${dateTime.day}/${dateTime.month} • $timeStr";
    }
  }

  // ------------------- Khi không có task -------------------
  Widget _emptyMessage(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text,
          style: GoogleFonts.poppins(
              color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
    );
  }
}
