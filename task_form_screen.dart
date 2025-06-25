import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class TaskFormScreen extends StatelessWidget {
  final TaskModel? taskToEdit;

  TaskFormScreen({this.taskToEdit, super.key});

  final title = TextEditingController();
  final desc = TextEditingController();
  final priority = RxString("Medium");
  final dueDate = Rxn<DateTime>();

  final controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    // Prefill if editing
    if (taskToEdit != null) {
      title.text = taskToEdit!.title;
      desc.text = taskToEdit!.description;
      priority.value = taskToEdit!.priority;
      dueDate.value = taskToEdit!.dueDate;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(taskToEdit == null ? "New Task" : "Edit Task"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 65, 139, 212),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //Title Field
            TextField(
              controller: title,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),

            //Description Field
            TextField(
              controller: desc,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 16),

            //Priority Dropdown
            Obx(() => Row(
              children: [
                const Icon(Icons.flag, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: priority.value,
                    decoration: const InputDecoration(
                      labelText: "Priority",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => priority.value = val!,
                    items: ['High', 'Medium', 'Low']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                ),
              ],
            )),
            const SizedBox(height: 16),

            //Date & Time Picker
            ElevatedButton.icon(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: dueDate.value ?? DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 9, minute: 0),
                  );
                  if (pickedTime != null) {
                    final fullDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    if (fullDateTime.isBefore(DateTime.now().add(const Duration(minutes: 1)))) {
                      Get.snackbar("Invalid Time", "Please pick a time at least 1 minute from now.");
                    } else {
                      dueDate.value = fullDateTime;
                    }
                  }
                }
              },
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              label: Obx(() => Text(
                dueDate.value == null
                    ? 'Pick Due Date & Time'
                    : 'Due: ${DateFormat('dd MMM yyyy – hh:mm a').format(dueDate.value!)}',
                style: const TextStyle(color: Colors.white),
              )),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 65, 139, 212),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 25),

            //Save/Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (title.text.isEmpty || dueDate.value == null) {
                    Get.snackbar("Error", "Please fill in all fields");
                    return;
                  }

                  if (taskToEdit != null) {
                    controller.updateTask(TaskModel(
                      id: taskToEdit!.id,
                      title: title.text,
                      description: desc.text,
                      priority: priority.value,
                      dueDate: dueDate.value!,
                      createdAt: taskToEdit!.createdAt,
                    ));
                  } else {
                    controller.addTask(
                      title.text,
                      desc.text,
                      priority.value,
                      dueDate.value!,
                    );
                  }

                  Get.back();
                },
                child: Text(
                  taskToEdit == null ? "Save Task" : "Update Task",
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 65, 139, 212),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
