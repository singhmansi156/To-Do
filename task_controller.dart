import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/task_model.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;
  var searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void addTask(String title, String desc, String priority, DateTime dueDate) {
    final newTask = TaskModel(
      id: const Uuid().v4(),
      title: title,
      description: desc,
      priority: priority,
      dueDate: dueDate,
      createdAt: DateTime.now(),
    );
    tasks.add(newTask);
    NotificationService().scheduleNotification(newTask);
    saveTasks();
  }

  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    saveTasks();
  }

  void updateTask(TaskModel updatedTask) {
    final idx = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (idx != -1) tasks[idx] = updatedTask;
    saveTasks();
  }

  void sortTasks(String by) {
    switch (by) {
      case 'Priority':
        tasks.sort((a, b) {
          const priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
          return priorityOrder[a.priority]!.compareTo(
            priorityOrder[b.priority]!,
          );
        });
        break;
      case 'Due Date':
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case 'Created':
        tasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
  }

  void saveTasks() {
    StorageService.saveTasks(tasks);
  }

  void loadTasks() {
    tasks.value = StorageService.loadTasks();
  }

  List<TaskModel> get filteredTasks {
    if (searchText.isEmpty) return tasks;
    return tasks
        .where(
          (t) =>
              t.title.toLowerCase().contains(searchText.value.toLowerCase()) ||
              t.description.toLowerCase().contains(
                searchText.value.toLowerCase(),
              ),
        )
        .toList();
  }
}
