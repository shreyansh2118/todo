import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/controller/controller.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/todo_item.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final TodoController controller =
      Get.put(TodoController()); // Ensure controller is initialized

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "My Todo",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left:8.0,right: 8),
        child: Column(
          children: [
            _search(), // Make sure this is wrapped in Obx if it uses observable values
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "All ToDos",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: controller.sortCriterion.value,
                  items: ['Date', 'Priority'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.sortTodos(newValue);
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () => showAddTodoDialog(context),
                  child: const Text("Add More"),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Obx(() {
              final todos = controller.filteredAndSortedTodos;
              print('Todos Length: ${todos.length}'); // Debug line
        
              if (todos.isEmpty) {
                return Center(child: Text("No TODOs found."));
              }
        
              return Expanded(
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return TodoItems(
                      todo: todo,
                      handleTodoCheckBox: controller.handleTodoCheckBox,
                      onDelete: controller.deleteTodo,
                      onEdit: (Todo updatedTodo) {
                        controller.updateTodo(todo, updatedTodo);
                      },
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _search() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        onChanged: controller.updateSearchTerm,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: 'Search',
          hintText: 'Enter todo title or description',
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
    );
  }

  void showAddTodoDialog(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController =
        TextEditingController();
    String _priority = 'Normal'; // Default priority

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Todo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: "Enter todo title",
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Enter todo description",
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['Very Urgent', 'Urgent', 'Normal'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _priority = newValue;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final description = _descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  controller.add(description, title, _priority);
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
