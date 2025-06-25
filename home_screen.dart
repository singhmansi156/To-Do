import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import 'task_form_screen.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  final controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo List"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) => controller.sortTasks(val),
            itemBuilder:
                (_) =>
                    ['Priority', 'Due Date', 'Created']
                        .map(
                          (e) => PopupMenuItem(
                            value: e,
                            child: Text("Sort by $e"),
                          ),
                        )
                        .toList(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: TextField(
              onChanged: (v) => controller.searchText.value = v,
              decoration: InputDecoration(
                hintText: 'Search your task...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.filteredTasks.length,
          itemBuilder: (_, i) => TaskTile(task: controller.filteredTasks[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => TaskFormScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
