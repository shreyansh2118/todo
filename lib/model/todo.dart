class Todo {
  final String id;
  final String title;
  final String description;
  final bool isdone;
  final String priority;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isdone,
    required this.priority,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isdone,
    String? priority,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isdone: isdone ?? this.isdone,
      priority: priority ?? this.priority,
    );
  }

  static List<Todo> todolist() {
    // Sample data
    return [
      Todo(
          id: '3',
          title: 'Call John',
          description: 'Discuss the new project',
          isdone: false,
          priority: 'Very Urgent'),
      Todo(
          id: '2',
          title: 'Complete project',
          description: 'Finish the project by end of the week',
          isdone: false,
          priority: 'Urgent'),
      Todo(
          id: '1',
          title: 'Buy groceries',
          description: 'Milk, Eggs, Bread',
          isdone: false,
          priority: 'Normal'),
      Todo(
          id: '6',
          title: 'Buy cars',
          description: 'BMW, RR',
          isdone: false,
          priority: 'Normal'),
    ];
  }
}
