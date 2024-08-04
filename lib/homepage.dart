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
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _textinput = TextEditingController();
  final TextEditingController _titleinput = TextEditingController();

  String _searchTerm = '';
  String _sortCriterion = 'Date'; // Default sort criterion

  // Define the priority levels with numerical values for sorting
  final Map<String, int> _priorityLevels = {
    'Very Urgent': 0,
    'Urgent': 1,
    'Normal': 2,
  };

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
        isdone: false,
        priority: 'Normal', // Default value for priority
        date: DateTime.now(), // Add a date field to your Todo model
      ));
    });
    _textinput.clear();
    _titleinput.clear();
  }

  void _updateSearchTerm(String term) {
    setState(() {
      _searchTerm = term;
    });
  }

  void _sortTodos(String criterion) {
    setState(() {
      _sortCriterion = criterion;
      if (criterion == 'Date') {
        todoList.sort((a, b) => b.date.compareTo(a.date)); // Sort by date
      } else if (criterion == 'Priority') {
        // Sort by priority using the defined priority levels
        todoList.sort((a, b) => _priorityLevels[a.priority]!.compareTo(_priorityLevels[b.priority]!));
      }
    });
  }

  List<Todo> get _filteredAndSortedTodos {
    List<Todo> filteredTodos = todoList
        .where((todo) =>
            todo.title.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            todo.description.toLowerCase().contains(_searchTerm.toLowerCase()))
        .toList();

    if (_sortCriterion == 'Date') {
      filteredTodos.sort((a, b) => b.date.compareTo(a.date));
    } else if (_sortCriterion == 'Priority') {
      filteredTodos.sort((a, b) => _priorityLevels[a.priority]!.compareTo(_priorityLevels[b.priority]!));
    }

    return filteredTodos;
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
                const Spacer(),
                DropdownButton<String>(
                  value: _sortCriterion,
                  items: ['Date', 'Priority'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _sortTodos(newValue);
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
            Expanded(
              child: ListView.builder(
                itemCount: _filteredAndSortedTodos.length,
                itemBuilder: (context, index) {
                  final todo = _filteredAndSortedTodos[index];
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
        controller: _searchController,
        onChanged: _updateSearchTerm,
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

  showAddTodoDialog(BuildContext context) {
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
                  items: ['Very Urgent', 'Urgent', 'Normal']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _priority = newValue;
                      });
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
                  todoList.add(Todo(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    description: description,
                    title: title,
                    isdone: false,
                    priority: _priority, // Use selected priority
                    date: DateTime.now(), // Add a date field to your Todo model
                  ));
                  _sortTodos(_sortCriterion); // Re-sort the list after adding
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
