import 'package:get_storage/get_storage.dart';
import '../models/task_model.dart';

class StorageService {
  static final box = GetStorage();

  static void saveTasks(List<TaskModel> tasks) {
    final json = tasks.map((e) => e.toJson()).toList();
    box.write('tasks', json);
  }

  static List<TaskModel> loadTasks() {
    final data = box.read<List>('tasks') ?? [];
    return data.map((e) => TaskModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
