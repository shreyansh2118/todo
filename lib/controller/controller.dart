import 'package:get/get.dart';
import 'package:todo/model/todo.dart';

class TodoController extends GetxController {
  var todoList = <Todo>[].obs;
  var searchTerm = ''.obs;
  var sortCriterion = 'Date'.obs;

  @override
  void onInit() {
    super.onInit();
    // Add sample data
    todoList.addAll(Todo.todolist());
  }

  List<Todo> get filteredAndSortedTodos {
    List<Todo> filteredTodos = todoList
        .where((todo) =>
            todo.title.toLowerCase().contains(searchTerm.value.toLowerCase()) ||
            todo.description
                .toLowerCase()
                .contains(searchTerm.value.toLowerCase()))
        .toList();

    if (sortCriterion.value == 'Date') {
      filteredTodos.sort((a, b) => b.date.compareTo(a.date));
    } else if (sortCriterion.value == 'Priority') {
      filteredTodos.sort((a, b) =>
          _priorityLevels[a.priority]!.compareTo(_priorityLevels[b.priority]!));
    }

    print('Filtered and Sorted Todos: $filteredTodos'); // Debug line
    return filteredTodos;
  }

  // Add a new todo and sort it based on the current sort criterion
  void add(String description, String title, String priority) {
    todoList.add(Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: description,
      title: title,
      isdone: false,
      priority: priority,
      date: DateTime.now(),
    ));
    sortTodos(sortCriterion.value); // Re-sort the list after adding
  }

  // Update the sort criterion and trigger re-sorting
  void sortTodos(String criterion) {
    sortCriterion.value = criterion;
  }

  // Update the search term
  void updateSearchTerm(String term) {
    searchTerm.value = term;
  }

  // Handle the checkbox state change
  void handleTodoCheckBox(Todo todo) {
    int index = todoList.indexOf(todo);
    if (index != -1) {
      todoList[index] = todo.copyWith(isdone: !todo.isdone);
    }
  }

  // Delete a todo by its ID
  void deleteTodo(String id) {
    todoList.removeWhere((item) => item.id == id);
  }

  // Update an existing todo
  void updateTodo(Todo oldTodo, Todo updatedTodo) {
    int index = todoList.indexOf(oldTodo);
    if (index != -1) {
      todoList[index] = updatedTodo;
    }
  }

  // Priority levels for sorting
  final Map<String, int> _priorityLevels = {
    'Very Urgent': 0,
    'Urgent': 1,
    'Normal': 2,
  };
}
