
import 'package:flutter/material.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {

  // Updated callback for API connection
  final Future<void> Function(Task) onSave;

  const AddTaskScreen({
    super.key,
    required this.onSave,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDate;

  String selectedPriority = "Medium";

  bool isSaving = false;


  // Date picker function
  Future<void> selectDueDate() async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  // Save task function
  Future<void> saveTask() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (isSaving) return;

    final task = Task(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      dueDate: selectedDate ?? DateTime.now(),
      priority: selectedPriority,
    );

    setState(() {
      isSaving = true;
    });

    try {

      // Send task to HomeScreen API callback
      await widget.onSave(task);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task saved successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Task save failed: $e"),
          backgroundColor: Colors.red,
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }


  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FC),

      appBar: AppBar(
        title: const Text(
          "Create New Task",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF242B45),
        elevation: 0,
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Form(

            key: _formKey,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    color: const Color(0xFF2878F0),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Icon(
                        Icons.add_task,
                        color: Colors.white,
                        size: 35,
                      ),

                      SizedBox(height: 12),

                      Text(
                        "Plan your day!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Add your task and stay productive.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Task title
                const Text(
                  "Task Title",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: titleController,

                  decoration: InputDecoration(
                    hintText: "Enter task title",
                    prefixIcon: const Icon(Icons.edit_note),

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter task title";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 22),

                // Description
                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: descriptionController,
                  maxLines: 4,

                  decoration: InputDecoration(
                    hintText: "Write task details...",
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.description),

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Due date
                const Text(
                  "Due Date",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                InkWell(
                  onTap: isSaving ? null : selectDueDate,

                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(17),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: Row(
                      children: [

                        const Icon(
                          Icons.calendar_month,
                          color: Color(0xFF2878F0),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? "Select task deadline"
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          ),
                        ),

                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Priority
                const Text(
                  "Priority Level",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,

                  children: ["Low", "Medium", "High"].map((priority) {

                    final isSelected =
                        selectedPriority == priority;

                    return ChoiceChip(
                      label: Text(priority),

                      selected: isSelected,

                      onSelected: isSaving ? null : (selected) {
                        setState(() {
                          selectedPriority = priority;
                        });
                      },

                      selectedColor: const Color(0xFF2878F0),

                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black87,
                      ),
                    );

                  }).toList(),
                ),

                const SizedBox(height: 32),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton.icon(

                    onPressed: isSaving ? null : saveTask,

                    icon: isSaving
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.save),

                    label: Text(
                      isSaving ? "SAVING..." : "SAVE TASK",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2878F0),
                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
