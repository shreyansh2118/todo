import 'package:flutter/material.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/todo_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Todo> todoList = Todo.todolist();
  final TextEditingController _textinput = TextEditingController();
  final TextEditingController _titleinput = TextEditingController();

  void _handleTodoCheckBox(Todo todo) {
    setState(() {
      // Update `isdone` using `copyWith` to create a new Todo object
      final updatedTodo = todo.copyWith(isdone: !todo.isdone);
      final index = todoList.indexOf(todo);
      if (index != -1) {
        todoList[index] = updatedTodo;
      }
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      todoList.removeWhere((item) => item.id == id);
    });
  }

  void _add(String description, String title) {
    setState(() {
      todoList.add(Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: description,
        title: title,
        isdone: false, priority: 'Normal', // Default value for isdone
      ));
    });
    _textinput.clear();
    _titleinput.clear();
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _search(),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "All ToDos",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                const Spacer(), // Use Spacer to push the button to the right
                ElevatedButton(
                  onPressed: () => showAddTodoDialog(context),
                  child: const Text("Add More"),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  final todo = todoList[index];
                  return TodoItems(
                    todo: todo,
                    handleTodoCheckBox: _handleTodoCheckBox,
                    onDelete: _deleteTodo,
                    onEdit: (Todo updatedTodo) {
                      setState(() {
                        final index = todoList.indexOf(todo);
                        if (index != -1) {
                          todoList[index] = updatedTodo;
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _search() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: 'Search',
          hintText: 'Enter todo letter',
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
    );
  }

  showAddTodoDialog(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController =
        TextEditingController();

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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final description = _descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  _add(description,
                      title); // Call _add method to add the new todo
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
